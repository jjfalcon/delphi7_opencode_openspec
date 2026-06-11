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
    function EditUser(const AUserId, AUsername, APassword: string;
      ARole: TUserRole; out AError: string): Boolean;
    function DeleteUser(const AUserId: string; out AError: string): Boolean;
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
  FRepo.Add(LUser);
  Result := True;
end;

function TUserManagementService.GetUsers: TList;
begin
  if FPermission.IsAdmin then
    Result := FRepo.FindAll
  else
    Result := nil;
end;

function TUserManagementService.EditUser(const AUserId, AUsername,
  APassword: string; ARole: TUserRole; out AError: string): Boolean;
var
  LUser: TUser;
  LExisting: TUser;
begin
  AError := '';
  Result := False;

  if not FPermission.IsAdmin then
  begin
    AError := 'admin_permission_denied';
    Exit;
  end;

  if Trim(AUsername) = '' then
  begin
    AError := 'admin_username_required';
    Exit;
  end;

  LUser := FRepo.FindById(AUserId);
  if LUser = nil then
  begin
    AError := 'admin_user_not_found';
    Exit;
  end;

  if Trim(AUsername) <> LUser.Username then
  begin
    LExisting := FRepo.FindByUsername(Trim(AUsername));
    if LExisting <> nil then
    begin
      AError := 'admin_username_exists';
      Exit;
    end;
  end;

  LUser.Username := Trim(AUsername);
  LUser.Role := ARole;
  if Trim(APassword) <> '' then
  begin
    LUser.PasswordSalt := FHasher.GenerateSalt;
    LUser.PasswordHash := FHasher.Hash(APassword, LUser.PasswordSalt);
  end;

  FRepo.Update(LUser);
  Result := True;
end;

function TUserManagementService.DeleteUser(const AUserId: string;
  out AError: string): Boolean;
begin
  AError := '';
  Result := False;

  if not FPermission.IsAdmin then
  begin
    AError := 'admin_permission_denied';
    Exit;
  end;

  if FRepo.FindById(AUserId) = nil then
  begin
    AError := 'admin_user_not_found';
    Exit;
  end;

  FRepo.Delete(AUserId);
  Result := True;
end;

end.
