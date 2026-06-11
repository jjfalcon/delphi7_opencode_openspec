unit UserAdminFrame;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  AppCoreUser, AppCoreUserManagement, AppCoreLocalization;

type
  TFrameUserAdmin = class(TFrame)
    LblTitle: TLabel;
    LstUsers: TListBox;
    GrpCreate: TGroupBox;
    LblNewUsername: TLabel;
    EdtNewUsername: TEdit;
    LblNewPassword: TLabel;
    EdtNewPassword: TEdit;
    LblNewRole: TLabel;
    CboNewRole: TComboBox;
    BtnCreateUser: TButton;
    LblError: TLabel;
    procedure BtnCreateUserClick(Sender: TObject);
  private
    FUserMgmt: TUserManagementService;
    FLocalization: TLocalizationService;
    procedure UpdateTexts;
    procedure RefreshUserList;
  public
    procedure Configure(AUserMgmt: TUserManagementService;
      ALocalization: TLocalizationService);
  end;

implementation

{$R *.dfm}

procedure TFrameUserAdmin.Configure(AUserMgmt: TUserManagementService;
  ALocalization: TLocalizationService);
begin
  FUserMgmt := AUserMgmt;
  FLocalization := ALocalization;

  CboNewRole.Items.Clear;
  CboNewRole.Items.AddObject(FLocalization.GetString('admin_role_user'), TObject(urUser));
  CboNewRole.Items.AddObject(FLocalization.GetString('admin_role_admin'), TObject(urAdmin));
  CboNewRole.ItemIndex := 0;

  UpdateTexts;
  RefreshUserList;
end;

procedure TFrameUserAdmin.UpdateTexts;
begin
  LblTitle.Caption := FLocalization.GetString('admin_title');
  GrpCreate.Caption := FLocalization.GetString('admin_create_group');
  LblNewUsername.Caption := FLocalization.GetString('login_username');
  LblNewPassword.Caption := FLocalization.GetString('login_password');
  LblNewRole.Caption := FLocalization.GetString('admin_role');
  BtnCreateUser.Caption := FLocalization.GetString('admin_btn_create');
  LblError.Caption := '';
end;

procedure TFrameUserAdmin.RefreshUserList;
var
  LList: TList;
  I: Integer;
  LUser: TUser;
begin
  LstUsers.Items.BeginUpdate;
  try
    LstUsers.Clear;
    LList := FUserMgmt.GetUsers;
    if LList <> nil then
      for I := 0 to LList.Count - 1 do
      begin
        LUser := TUser(LList[I]);
        if LUser.Role = urAdmin then
          LstUsers.Items.Add(LUser.Username + ' (' + FLocalization.GetString('admin_role_admin') + ')')
        else
          LstUsers.Items.Add(LUser.Username + ' (' + FLocalization.GetString('admin_role_user') + ')');
      end;
  finally
    LstUsers.Items.EndUpdate;
  end;
end;

procedure TFrameUserAdmin.BtnCreateUserClick(Sender: TObject);
var
  LRole: TUserRole;
  LError: string;
begin
  LblError.Caption := '';

  if CboNewRole.ItemIndex >= 0 then
    LRole := TUserRole(CboNewRole.Items.Objects[CboNewRole.ItemIndex])
  else
    LRole := urUser;

  if FUserMgmt.CreateUser(EdtNewUsername.Text, EdtNewPassword.Text,
    LRole, LError) then
  begin
    EdtNewUsername.Text := '';
    EdtNewPassword.Text := '';
    CboNewRole.ItemIndex := 0;
    RefreshUserList;
  end
  else
    LblError.Caption := FLocalization.GetString(LError);
end;

end.
