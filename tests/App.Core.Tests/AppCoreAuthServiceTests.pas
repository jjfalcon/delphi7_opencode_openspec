unit AppCoreAuthServiceTests;

interface

procedure RunAuthServiceTests(var AFailures: Integer);

implementation

uses
  SysUtils,
  Classes,
  IniFiles,
  ActiveX,
  AppCoreUser,
  AppCoreUserRepository,
  AppCoreAuth,
  AppCoreClock,
  AppCorePreferences,
  AppCoreTestUtils;

{ --- TUser tests --- }

procedure Test_User_Create_AssignsFields;
var
  LUser: TUser;
begin
  LUser := TUser.Create('u1', 'admin', urAdmin);
  try
    AssertEquals('u1', LUser.Id, 'User.Id should match constructor');
    AssertEquals('admin', LUser.Username, 'User.Username should match constructor');
    AssertTrue(LUser.Role = urAdmin, 'User.Role should be urAdmin');
    AssertTrue(not LUser.IsLocked, 'User should not be locked by default');
    AssertEquals(0, LUser.FailedLoginAttempts, 'FailedLoginAttempts should be 0 by default');
  finally
    LUser.Free;
  end;
end;

{ --- TInMemoryUserRepository tests --- }

procedure Test_Repo_SaveAndFindById;
var
  LRepo: IUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LUser := TUser.Create('', 'alice', urUser);
  LRepo.Add(LUser);
  LFound := LRepo.FindById(LUser.Id);
  AssertTrue(LFound <> nil, 'Should find user by Id');
  AssertEquals('alice', LFound.Username, 'Username should match');
end;

procedure Test_Repo_FindByUsername_Existing;
var
  LRepo: IUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LUser := TUser.Create('u1', 'bob', urUser);
  LRepo.Add(LUser);
  LFound := LRepo.FindByUsername('bob');
  AssertTrue(LFound <> nil, 'Should find user by username');
  AssertEquals('u1', LFound.Id, 'Id should match');
end;

procedure Test_Repo_FindByUsername_CaseInsensitive;
var
  LRepo: IUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LUser := TUser.Create('u1', 'Bob', urUser);
  LRepo.Add(LUser);
  LFound := LRepo.FindByUsername('bob');
  AssertTrue(LFound <> nil, 'Username search should be case-insensitive');
end;

procedure Test_Repo_FindByUsername_NotFound;
var
  LRepo: IUserRepository;
  LFound: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LFound := LRepo.FindByUsername('nonexistent');
  AssertTrue(LFound = nil, 'Should return nil for unknown username');
end;

procedure Test_Repo_FindAll_ReturnsAll;
var
  LRepo: IUserRepository;
  LList: TList;
begin
  LRepo := TInMemoryUserRepository.Create;
  LRepo.Add(TUser.Create('', 'u1', urUser));
  LRepo.Add(TUser.Create('', 'u2', urAdmin));
  LList := LRepo.FindAll;
  AssertEquals(2, LList.Count, 'FindAll should return all users');
end;

procedure Test_Repo_Save_UpdateExisting;
var
  LRepo: IUserRepository;
  LUser: TUser;
  LFound: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LUser := TUser.Create('u1', 'alice', urUser);
  LRepo.Add(LUser);
  LUser := TUser.Create('u1', 'alice_updated', urAdmin);
  LRepo.Update(LUser);
  LUser.Free;
  LFound := LRepo.FindById('u1');
  AssertEquals('alice_updated', LFound.Username, 'Username should be updated');
end;

procedure Test_Repo_Delete_RemovesUser;
var
  LRepo: IUserRepository;
  LUser: TUser;
begin
  LRepo := TInMemoryUserRepository.Create;
  LUser := TUser.Create('u1', 'alice', urUser);
  LRepo.Add(LUser);
  LRepo.Delete('u1');
  AssertTrue(LRepo.FindById('u1') = nil, 'User should be removed after delete');
end;

{ --- TBasicPasswordHasher tests --- }

procedure Test_Hasher_ReturnsConsistentHash;
var
  LHasher: IPasswordHasher;
  LSalt: string;
begin
  LHasher := TBasicPasswordHasher.Create;
  LSalt := LHasher.GenerateSalt;
  AssertTrue(LSalt <> '', 'Salt should not be empty');
  AssertEquals(LHasher.Hash('pass123', LSalt),
    LHasher.Hash('pass123', LSalt), 'Same password and salt should produce same hash');
end;

procedure Test_Hasher_DifferentSalt_DifferentHash;
var
  LHasher: IPasswordHasher;
begin
  LHasher := TBasicPasswordHasher.Create;
  AssertTrue(LHasher.Hash('pass', 'salt1') <> LHasher.Hash('pass', 'salt2'),
    'Different salts should produce different hashes');
end;

{ --- TAuthService tests --- }

function CreateAuthService(out ARepo: IUserRepository;
  out AHasher: IPasswordHasher): TAuthService;
begin
  ARepo := TInMemoryUserRepository.Create;
  AHasher := TBasicPasswordHasher.Create;
  ARepo.Add(CreateTestUser('u1', 'alice', urUser, AHasher, 'secret'));
  Result := TAuthService.Create(ARepo, AHasher, 3);
end;

procedure Test_Auth_LoginSuccess;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  LResult := LAuth.Login('alice', 'secret', LUser);
  AssertTrue(LResult = lrSuccess, 'Login should succeed with valid credentials');
  AssertTrue(LUser <> nil, 'User should be returned on success');
end;

procedure Test_Auth_LoginInvalidPassword;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  LResult := LAuth.Login('alice', 'wrong', LUser);
  AssertTrue(LResult = lrInvalidCredentials, 'Wrong password should be rejected');
  AssertTrue(LUser = nil, 'User should be nil on failure');
end;

procedure Test_Auth_LoginNonExistentUser;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LResult: TLoginResult;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LAuth := TAuthService.Create(LRepo, LHasher, 3);
  LResult := LAuth.Login('unknown', 'pass', LUser);
  AssertTrue(LResult = lrInvalidCredentials, 'Non-existent user should be rejected');
end;

procedure Test_Auth_EmptyUsername;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  LResult := LAuth.Login('', 'secret', LUser);
  AssertTrue(LResult = lrUsernameRequired, 'Empty username should be rejected');
end;

procedure Test_Auth_EmptyPassword;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  LResult := LAuth.Login('alice', '', LUser);
  AssertTrue(LResult = lrPasswordRequired, 'Empty password should be rejected');
end;

procedure Test_Auth_LockoutAfter3Failures;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  I: Integer;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  for I := 1 to 3 do
    LAuth.Login('alice', 'wrong', LUser);
  LResult := LAuth.Login('alice', 'secret', LUser);
  AssertTrue(LResult = lrAccountLocked, 'Account should be locked after 3 failures');
end;

procedure Test_Auth_SuccessResetsFailedCounter;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LFound: TUser;
  LResult: TLoginResult;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  LAuth.Login('alice', 'wrong', LUser);
  LAuth.Login('alice', 'secret', LUser);
  LFound := LRepo.FindByUsername('alice');
  AssertEquals(0, LFound.FailedLoginAttempts, 'Failed attempts should reset after success');
end;

procedure Test_Auth_LockoutPersistsInRepo;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAuth: TAuthService;
  LUser: TUser;
  LFound: TUser;
  I: Integer;
begin
  LAuth := CreateAuthService(LRepo, LHasher);
  for I := 1 to 3 do
    LAuth.Login('alice', 'wrong', LUser);
  LFound := LRepo.FindByUsername('alice');
  AssertTrue(LFound.IsLocked, 'Lockout should persist in repo after 3 failures');
  AssertEquals(3, LFound.FailedLoginAttempts,
    'Failed attempts should persist in repo');
end;

{ --- TSessionService tests --- }

procedure Test_Session_IsActiveAfterLogin;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'alice', urUser);
  LSession.StartSession(LUser);
  AssertTrue(LSession.IsActive, 'Session should be active after login');
  LSession.Free;
end;

procedure Test_Session_ExpiresAfterTimeout;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'alice', urUser);
  LSession.StartSession(LUser);
  LClock.AdvanceMinutes(6);
  AssertTrue(not LSession.IsActive, 'Session should expire after timeout');
  LSession.Free;
end;

procedure Test_Session_TouchPreventsExpiry;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'alice', urUser);
  LSession.StartSession(LUser);
  LClock.AdvanceMinutes(3);
  LSession.Touch;
  LClock.AdvanceMinutes(3);
  AssertTrue(LSession.IsActive, 'Session should remain active after touch');
  LSession.Free;
end;

procedure Test_Session_NotActiveAfterEnd;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'alice', urUser);
  LSession.StartSession(LUser);
  LSession.EndSession;
  AssertTrue(not LSession.IsActive, 'Session should not be active after EndSession');
  LSession.Free;
end;

{ --- TPermissionService tests --- }

procedure Test_Permission_AdminReturnsTrue;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'admin', urAdmin);
  LSession.StartSession(LUser);
  LPerm := TPermissionService.Create(LSession);
  AssertTrue(LPerm.IsAdmin, 'Admin user should have admin permission');
  LSession.Free;
end;

procedure Test_Permission_RegularUserIsNotAdmin;
var
  LClock: TMutableClock;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 10));
  LSession := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('u1', 'user', urUser);
  LSession.StartSession(LUser);
  LPerm := TPermissionService.Create(LSession);
  AssertTrue(not LPerm.IsAdmin, 'Regular user should not have admin permission');
  LSession.Free;
end;

{ --- TLoginPreferences tests --- }

procedure Test_Preferences_SaveAndLoadLastUsername;
var
  LPref: ILoginPreferences;
  LTempFile: string;
begin
  LTempFile := ExtractFilePath(ParamStr(0)) + 'test_prefs.ini';
  LPref := TLoginPreferences.Create(LTempFile);
  LPref.SaveLastUsername('alice');
  AssertEquals('alice', LPref.LoadLastUsername, 'Should load saved username');
  DeleteFile(LTempFile);
end;

{ --- Runner --- }

procedure RunAuthServiceTests(var AFailures: Integer);
begin
  TestCount := 0;
  FailCount := 0;

  Writeln('--- Auth Service Tests ---');

  Test_User_Create_AssignsFields;

  Test_Repo_SaveAndFindById;
  Test_Repo_FindByUsername_Existing;
  Test_Repo_FindByUsername_CaseInsensitive;
  Test_Repo_FindByUsername_NotFound;
  Test_Repo_FindAll_ReturnsAll;
  Test_Repo_Save_UpdateExisting;
  Test_Repo_Delete_RemovesUser;

  Test_Hasher_ReturnsConsistentHash;
  Test_Hasher_DifferentSalt_DifferentHash;

  Test_Auth_LoginSuccess;
  Test_Auth_LoginInvalidPassword;
  Test_Auth_LoginNonExistentUser;
  Test_Auth_EmptyUsername;
  Test_Auth_EmptyPassword;
  Test_Auth_LockoutAfter3Failures;
  Test_Auth_SuccessResetsFailedCounter;
  Test_Auth_LockoutPersistsInRepo;

  Test_Session_IsActiveAfterLogin;
  Test_Session_ExpiresAfterTimeout;
  Test_Session_TouchPreventsExpiry;
  Test_Session_NotActiveAfterEnd;

  Test_Permission_AdminReturnsTrue;
  Test_Permission_RegularUserIsNotAdmin;

  Test_Preferences_SaveAndLoadLastUsername;

  if FailCount = 0 then
    Writeln('All auth tests passed.')
  else
    Writeln(IntToStr(FailCount) + '/' + IntToStr(TestCount) + ' test(s) failed.');

  AFailures := AFailures + FailCount;
end;

end.
