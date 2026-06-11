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
    BtnEditUser: TButton;
    BtnDeleteUser: TButton;
    LblError: TLabel;
    procedure BtnCreateUserClick(Sender: TObject);
    procedure BtnEditUserClick(Sender: TObject);
    procedure BtnDeleteUserClick(Sender: TObject);
    procedure LstUsersClick(Sender: TObject);
  private
    FUserMgmt: TUserManagementService;
    FLocalization: TLocalizationService;
    FSelectedUserId: string;
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
  FSelectedUserId := '';

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
  BtnEditUser.Caption := FLocalization.GetString('admin_btn_edit');
  BtnDeleteUser.Caption := FLocalization.GetString('admin_btn_delete');
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
          LstUsers.Items.AddObject(LUser.Username + ' (' + FLocalization.GetString('admin_role_admin') + ')',
            TObject(LUser))
        else
          LstUsers.Items.AddObject(LUser.Username + ' (' + FLocalization.GetString('admin_role_user') + ')',
            TObject(LUser));
      end;
  finally
    LstUsers.Items.EndUpdate;
  end;
  FSelectedUserId := '';
  BtnEditUser.Enabled := False;
  BtnDeleteUser.Enabled := False;
end;

procedure TFrameUserAdmin.LstUsersClick(Sender: TObject);
var
  LUser: TUser;
  I: Integer;
begin
  if LstUsers.ItemIndex >= 0 then
  begin
    LUser := TUser(LstUsers.Items.Objects[LstUsers.ItemIndex]);
    FSelectedUserId := LUser.Id;
    BtnEditUser.Enabled := True;
    BtnDeleteUser.Enabled := True;
    EdtNewUsername.Text := LUser.Username;
    EdtNewPassword.Text := '';
    for I := 0 to CboNewRole.Items.Count - 1 do
      if TUserRole(CboNewRole.Items.Objects[I]) = LUser.Role then
      begin
        CboNewRole.ItemIndex := I;
        Break;
      end;
  end
  else
  begin
    FSelectedUserId := '';
    BtnEditUser.Enabled := False;
    BtnDeleteUser.Enabled := False;
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

procedure TFrameUserAdmin.BtnEditUserClick(Sender: TObject);
var
  LRole: TUserRole;
  LError: string;
begin
  LblError.Caption := '';
  if FSelectedUserId = '' then
    Exit;

  if CboNewRole.ItemIndex >= 0 then
    LRole := TUserRole(CboNewRole.Items.Objects[CboNewRole.ItemIndex])
  else
    LRole := urUser;

  if FUserMgmt.EditUser(FSelectedUserId, EdtNewUsername.Text,
    EdtNewPassword.Text, LRole, LError) then
  begin
    EdtNewUsername.Text := '';
    EdtNewPassword.Text := '';
    CboNewRole.ItemIndex := 0;
    RefreshUserList;
  end
  else
    LblError.Caption := FLocalization.GetString(LError);
end;

procedure TFrameUserAdmin.BtnDeleteUserClick(Sender: TObject);
var
  LError: string;
begin
  LblError.Caption := '';
  if FSelectedUserId = '' then
    Exit;

  if MessageDlg(FLocalization.GetString('admin_confirm_delete'),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if FUserMgmt.DeleteUser(FSelectedUserId, LError) then
    begin
      EdtNewUsername.Text := '';
      EdtNewPassword.Text := '';
      CboNewRole.ItemIndex := 0;
      RefreshUserList;
    end
    else
      LblError.Caption := FLocalization.GetString(LError);
  end;
end;

end.
