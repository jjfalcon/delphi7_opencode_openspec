unit AppCoreUserManagementTests;

interface

procedure RunUserManagementTests(var AFailures: Integer);

implementation

uses
  SysUtils,
  Classes,
  AppCoreUser,
  AppCoreUserRepository,
  AppCoreAuth,
  AppCoreClock,
  AppCoreUserManagement,
  AppCoreTestUtils;

function CreateAdminSession: TSessionService;
var
  LClock: TMutableClock;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 11));
  Result := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('', 'admin', urAdmin);
  Result.StartSession(LUser);
end;

function CreateUserSession: TSessionService;
var
  LClock: TMutableClock;
  LUser: TUser;
begin
  LClock := TMutableClock.Create(EncodeDate(2026, 6, 11));
  Result := TSessionService.Create(LClock, 5);
  LUser := TUser.Create('', 'user', urUser);
  Result.StartSession(LUser);
end;

function CreateUserMgmtService(out ARepo: IUserRepository;
  out ASession: TSessionService): TUserManagementService;
var
  LHasher: IPasswordHasher;
  LPerm: TPermissionService;
begin
  ARepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  ASession := CreateAdminSession;
  LPerm := TPermissionService.Create(ASession);
  Result := TUserManagementService.Create(ARepo, LHasher, LPerm);
end;

{ --- Tests --- }

procedure Test_UserMgmt_CreateUserSuccess;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
  LUser: TUser;
  LError: string;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    AssertTrue(LService.CreateUser('bob', 'pass123', urUser, LError),
      'CreateUser should succeed with valid data');
    AssertEquals('', LError, 'Error should be empty on success');

    LUser := LRepo.FindByUsername('bob');
    AssertTrue(LUser <> nil, 'User should exist in repo');
    AssertTrue(LUser.Role = urUser, 'Role should be urUser');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_RejectEmptyUsername;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
  LError: string;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    AssertTrue(not LService.CreateUser('', 'pass', urUser, LError),
      'CreateUser should reject empty username');
    AssertEquals('admin_username_required', LError,
      'Error should be admin_username_required');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_RejectEmptyPassword;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
  LError: string;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    AssertTrue(not LService.CreateUser('bob', '', urUser, LError),
      'CreateUser should reject empty password');
    AssertEquals('admin_password_required', LError,
      'Error should be admin_password_required');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_RejectDuplicateUsername;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
  LError: string;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    AssertTrue(LService.CreateUser('bob', 'pass', urUser, LError),
      'First creation should succeed');
    AssertTrue(not LService.CreateUser('bob', 'other', urUser, LError),
      'Second creation with same username should fail');
    AssertEquals('admin_username_exists', LError,
      'Error should be admin_username_exists');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_GetUsers;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
  LList: TList;
  LError: string;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    LService.CreateUser('bob', 'pass', urUser, LError);
    LService.CreateUser('alice', 'pass', urAdmin, LError);

    LList := LService.GetUsers;
    AssertEquals(2, LList.Count, 'GetUsers should return all users');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_CanManageForAdmin;
var
  LRepo: IUserRepository;
  LSession: TSessionService;
  LService: TUserManagementService;
begin
  LService := CreateUserMgmtService(LRepo, LSession);
  try
    AssertTrue(LService.CanManage, 'Admin should be able to manage users');
  finally
    LSession.Free;
  end;
end;

procedure Test_UserMgmt_CanManageForRegularUser;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateUserSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);
  try
    AssertTrue(not LService.CanManage,
      'Regular user should not be able to manage users');
  finally
    LSession.Free;
  end;
end;

{ --- Runner --- }

procedure RunUserManagementTests(var AFailures: Integer);
begin
  TestCount := 0;
  FailCount := 0;

  Writeln('--- User Management Tests ---');

  Test_UserMgmt_CreateUserSuccess;
  Test_UserMgmt_RejectEmptyUsername;
  Test_UserMgmt_RejectEmptyPassword;
  Test_UserMgmt_RejectDuplicateUsername;
  Test_UserMgmt_GetUsers;
  Test_UserMgmt_CanManageForAdmin;
  Test_UserMgmt_CanManageForRegularUser;

  if FailCount = 0 then
    Writeln('All user management tests passed.')
  else
    Writeln(IntToStr(FailCount) + '/' + IntToStr(TestCount) +
      ' test(s) failed.');

  AFailures := AFailures + FailCount;
end;

end.
