unit AppCoreUserManagement;

interface

uses
  Classes,
  AppCoreUser,
  AppCoreUserRepository,
  AppCoreAuth;

type
  TUserManagementService = class
  private
    FRepo: IUserRepository;
    FHasher: IPasswordHasher;
    FPermission: TPermissionService;
  public
    constructor Create(ARepo: IUserRepository; AHasher: IPasswordHasher;
      APermission: TPermissionService);
    function CreateUser(const AUsername, APassword: string; ARole: TUserRole;
      out AError: string): Boolean;
    function GetUsers: TList;
    function CanManage: Boolean;
  end;

implementation

uses
  SysUtils;

constructor TUserManagementService.Create(ARepo: IUserRepository;
  AHasher: IPasswordHasher; APermission: TPermissionService);
begin
  inherited Create;
  FRepo := ARepo;
  FHasher := AHasher;
  FPermission := APermission;
end;

function TUserManagementService.CanManage: Boolean;
begin
  Result := FPermission.IsAdmin;
end;

function TUserManagementService.CreateUser(const AUsername, APassword: string;
  ARole: TUserRole; out AError: string): Boolean;
var
  LUser: TUser;
begin
  AError := '';
  Result := False;

  if Trim(AUsername) = '' then
  begin
    AError := 'admin_username_required';
    Exit;
  end;

  if Trim(APassword) = '' then
  begin
    AError := 'admin_password_required';
    Exit;
  end;

  if FRepo.FindByUsername(Trim(AUsername)) <> nil then
  begin
    AError := 'admin_username_exists';
    Exit;
  end;

  LUser := TUser.Create('', Trim(AUsername), ARole);
  LUser.PasswordSalt := FHasher.GenerateSalt;
  LUser.PasswordHash := FHasher.Hash(APassword, LUser.PasswordSalt);
  FRepo.Save(LUser);
  Result := True;
end;

function TUserManagementService.GetUsers: TList;
begin
  if FPermission.IsAdmin then
    Result := FRepo.FindAll
  else
    Result := nil;
end;

end.
