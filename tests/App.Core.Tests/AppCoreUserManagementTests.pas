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
  AppCoreUserManagement;

type
  TMutableClock = class(TInterfacedObject, IClock)
  private
    FNow: TDateTime;
  public
    constructor Create(const ANow: TDateTime);
    function Now: TDateTime;
  end;

constructor TMutableClock.Create(const ANow: TDateTime);
begin
  inherited Create;
  FNow := ANow;
end;

function TMutableClock.Now: TDateTime;
begin
  Result := FNow;
end;

var
  TestCount: Integer;
  FailCount: Integer;

procedure AssertTrue(ACondition: Boolean; const AMessage: string);
begin
  Inc(TestCount);
  if not ACondition then
  begin
    Writeln('FAIL: ' + AMessage);
    Inc(FailCount);
  end
  else
    Writeln('PASS: ' + AMessage);
end;

procedure AssertEquals(AExpected, AActual: string; const AMessage: string); overload;
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected "' + AExpected +
    '", got "' + AActual + '".');
end;

procedure AssertEquals(AExpected, AActual: Integer; const AMessage: string); overload;
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected ' + IntToStr(AExpected) +
    ', got ' + IntToStr(AActual) + '.');
end;

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

{ --- Tests --- }

procedure Test_UserMgmt_CreateUserSuccess;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
  LUser: TUser;
  LError: string;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  AssertTrue(LService.CreateUser('bob', 'pass123', urUser, LError),
    'CreateUser should succeed with valid data');
  AssertEquals('', LError, 'Error should be empty on success');

  LUser := LRepo.FindByUsername('bob');
  AssertTrue(LUser <> nil, 'User should exist in repo');
  AssertTrue(LUser.Role = urUser, 'Role should be urUser');

  LSession.Free;
end;

procedure Test_UserMgmt_RejectEmptyUsername;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
  LError: string;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  AssertTrue(not LService.CreateUser('', 'pass', urUser, LError),
    'CreateUser should reject empty username');
  AssertEquals('admin_username_required', LError,
    'Error should be admin_username_required');

  LSession.Free;
end;

procedure Test_UserMgmt_RejectEmptyPassword;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
  LError: string;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  AssertTrue(not LService.CreateUser('bob', '', urUser, LError),
    'CreateUser should reject empty password');
  AssertEquals('admin_password_required', LError,
    'Error should be admin_password_required');

  LSession.Free;
end;

procedure Test_UserMgmt_RejectDuplicateUsername;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
  LError: string;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  AssertTrue(LService.CreateUser('bob', 'pass', urUser, LError),
    'First creation should succeed');
  AssertTrue(not LService.CreateUser('bob', 'other', urUser, LError),
    'Second creation with same username should fail');
  AssertEquals('admin_username_exists', LError,
    'Error should be admin_username_exists');

  LSession.Free;
end;

procedure Test_UserMgmt_GetUsers;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
  LList: TList;
  LError: string;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  LService.CreateUser('bob', 'pass', urUser, LError);
  LService.CreateUser('alice', 'pass', urAdmin, LError);

  LList := LService.GetUsers;
  AssertEquals(2, LList.Count, 'GetUsers should return all users');

  LSession.Free;
end;

procedure Test_UserMgmt_CanManageForAdmin;
var
  LRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LSession: TSessionService;
  LPerm: TPermissionService;
  LService: TUserManagementService;
begin
  LRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;
  LSession := CreateAdminSession;
  LPerm := TPermissionService.Create(LSession);
  LService := TUserManagementService.Create(LRepo, LHasher, LPerm);

  AssertTrue(LService.CanManage, 'Admin should be able to manage users');

  LSession.Free;
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

  AssertTrue(not LService.CanManage,
    'Regular user should not be able to manage users');

  LSession.Free;
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
