unit AppCoreRepositoryTests;

interface

procedure RunRepositoryTests(var AFailures: Integer);

implementation

uses
  SysUtils,
  Classes,
  IniFiles,
  ActiveX,
  AppCoreUser,
  AppCoreUserRepository,
  AppCoreRepositoryFactory,
  AppCoreFileUserRepository,
  AppCoreTestUtils;

procedure CleanupRepo(const AConfigPath: string);
var
  LDataDir: string;
begin
  LDataDir := ExtractFilePath(AConfigPath) + 'data';
  DeleteFile(LDataDir + '\users.json');
  RemoveDir(LDataDir);
  DeleteFile(AConfigPath);
end;

{ --- TRepositoryFactory tests --- }

procedure Test_Factory_DefaultReturnsWorkingRepo;
var
  LConfigPath: string;
  LRepo: IUserRepository;
  LUser: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_factory_default.ini';
  with TIniFile.Create(LConfigPath) do
  try
    EraseSection('Repository');
  finally
    Free;
  end;
  LRepo := TRepositoryFactory.CreateRepository(LConfigPath);
  AssertTrue(LRepo <> nil, 'Factory should return a repository');
  LRepo.Add(CreateTestUser('', 'testuser', urUser, 'pass'));
  LUser := LRepo.FindByUsername('testuser');
  AssertTrue(LUser <> nil, 'Default repo should save and find users');
  DeleteFile(LConfigPath);
end;

procedure Test_Factory_FileRepoCreatesDataFile;
var
  LConfigPath: string;
  LRepo: IUserRepository;
  LDataFile: string;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_factory_file.ini';
  LDataFile := ExtractFilePath(LConfigPath) + 'data\users.json';
  with TIniFile.Create(LConfigPath) do
  try
    WriteString('Repository', 'Type', 'file');
  finally
    Free;
  end;
  LRepo := TRepositoryFactory.CreateRepository(LConfigPath);
  AssertTrue(LRepo <> nil, 'Factory should return a repository');
  LRepo.Add(CreateTestUser('', 'fileuser', urUser, 'pass'));
  AssertTrue(FileExists(LDataFile),
    'File repo should create data\users.json');
  LRepo := nil;
  CleanupRepo(LConfigPath);
end;

procedure Test_Factory_UnknownTypeDefaultsToMemory;
var
  LConfigPath: string;
  LRepo: IUserRepository;
  LUser: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_factory_unknown.ini';
  with TIniFile.Create(LConfigPath) do
  try
    WriteString('Repository', 'Type', 'mysql');
  finally
    Free;
  end;
  LRepo := TRepositoryFactory.CreateRepository(LConfigPath);
  AssertTrue(LRepo <> nil, 'Factory should return a repository');
  LRepo.Add(CreateTestUser('', 'unkuser', urUser, 'pass'));
  LUser := LRepo.FindByUsername('unkuser');
  AssertTrue(LUser <> nil, 'Unknown type repo should behave like memory');
  DeleteFile(LConfigPath);
end;

{ --- TFileUserRepository tests --- }

procedure Test_FileRepo_SaveAndFindById;
var
  LConfigPath: string;
  LRepo: TFileUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo.ini';
  LRepo := TFileUserRepository.Create(LConfigPath);
  LUser := CreateTestUser('', 'alice', urUser, 'secret');
  LRepo.Add(LUser);
  LFound := LRepo.FindById(LUser.Id);
  AssertTrue(LFound <> nil, 'Should find user by Id in file repo');
  AssertEquals('alice', LFound.Username, 'Username should match');
  LRepo.Free;
  CleanupRepo(LConfigPath);
end;

procedure Test_FileRepo_FindByUsername_Existing;
var
  LConfigPath: string;
  LRepo: TFileUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo2.ini';
  LRepo := TFileUserRepository.Create(LConfigPath);
  LUser := CreateTestUser('u1', 'bob', urUser, 'pass');
  LRepo.Add(LUser);
  LFound := LRepo.FindByUsername('bob');
  AssertTrue(LFound <> nil, 'Should find user by username in file repo');
  AssertEquals('u1', LFound.Id, 'Id should match');
  LRepo.Free;
  CleanupRepo(LConfigPath);
end;

procedure Test_FileRepo_FindByUsername_NotFound;
var
  LConfigPath: string;
  LRepo: TFileUserRepository;
  LFound: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo3.ini';
  LRepo := TFileUserRepository.Create(LConfigPath);
  LFound := LRepo.FindByUsername('nonexistent');
  AssertTrue(LFound = nil, 'Should return nil for unknown username in file repo');
  LRepo.Free;
  CleanupRepo(LConfigPath);
end;

procedure Test_FileRepo_FindAll_ReturnsAll;
var
  LConfigPath: string;
  LRepo: TFileUserRepository;
  LList: TList;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo4.ini';
  LRepo := TFileUserRepository.Create(LConfigPath);
  LRepo.Add(CreateTestUser('', 'u1', urUser, 'pass'));
  LRepo.Add(CreateTestUser('', 'u2', urAdmin, 'pass'));
  LList := LRepo.FindAll;
  AssertEquals(2, LList.Count, 'FindAll should return all users in file repo');
  LRepo.Free;
  CleanupRepo(LConfigPath);
end;

procedure Test_FileRepo_Delete_RemovesUser;
var
  LConfigPath: string;
  LRepo: TFileUserRepository;
  LUser: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo5.ini';
  LRepo := TFileUserRepository.Create(LConfigPath);
  LUser := CreateTestUser('', 'alice', urUser, 'secret');
  LRepo.Add(LUser);
  LRepo.Delete(LUser.Id);
  AssertTrue(LRepo.FindById(LUser.Id) = nil,
    'User should be removed after delete in file repo');
  LRepo.Free;
  CleanupRepo(LConfigPath);
end;

procedure Test_FileRepo_PersistenceAcrossInstances;
var
  LConfigPath: string;
  LRepo1: TFileUserRepository;
  LRepo2: TFileUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LConfigPath := ExtractFilePath(ParamStr(0)) + 'test_filerepo6.ini';
  LRepo1 := TFileUserRepository.Create(LConfigPath);
  LUser := CreateTestUser('', 'persist', urUser, 'test');
  LRepo1.Add(LUser);
  LRepo1.Free;

  LRepo2 := TFileUserRepository.Create(LConfigPath);
  LFound := LRepo2.FindByUsername('persist');
  if LFound <> nil then
    AssertEquals('persist', LFound.Username,
      'Username should persist')
  else
    AssertTrue(False,
      'User should persist across file repo instances');
  LRepo2.Free;
  CleanupRepo(LConfigPath);
end;

{ --- Runner --- }

procedure RunRepositoryTests(var AFailures: Integer);
begin
  TestCount := 0;
  FailCount := 0;

  Writeln('--- Repository Tests ---');

  Test_Factory_DefaultReturnsWorkingRepo;
  Test_Factory_FileRepoCreatesDataFile;
  Test_Factory_UnknownTypeDefaultsToMemory;

  Test_FileRepo_SaveAndFindById;
  Test_FileRepo_FindByUsername_Existing;
  Test_FileRepo_FindByUsername_NotFound;
  Test_FileRepo_FindAll_ReturnsAll;
  Test_FileRepo_Delete_RemovesUser;
  Test_FileRepo_PersistenceAcrossInstances;

  if FailCount = 0 then
    Writeln('All repository tests passed.')
  else
    Writeln(IntToStr(FailCount) + '/' + IntToStr(TestCount) +
      ' test(s) failed.');

  AFailures := AFailures + FailCount;
end;

end.
