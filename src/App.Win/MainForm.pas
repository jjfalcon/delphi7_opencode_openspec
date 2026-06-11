unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  AppCoreUser, AppCoreAuth, AppCoreLocalization, AppCorePreferences,
  AppCoreUserManagement, AppWinPreferencesFrame, AppWinUserAdminFrame;

type
  TFrmMain = class(TForm)
    PanelNav: TPanel;
    LstNav: TListBox;
    PanelTop: TPanel;
    LblWelcome: TLabel;
    LblRole: TLabel;
    BtnLogout: TButton;
    PanelCenter: TPanel;
    PanelWelcome: TPanel;
    LblWelcomeMsg: TLabel;
    LblRoleMsg: TLabel;
    procedure LstNavClick(Sender: TObject);
    procedure BtnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSession: TSessionService;
    FLoggedInUser: TUser;
    FLocalization: TLocalizationService;
    FLoginPreferences: ILoginPreferences;
    FUserMgmt: TUserManagementService;
    FramePreferences: TFramePreferences;
    FrameUserAdmin: TFrameUserAdmin;
    procedure CreateFrames;
    procedure FreeFrames;
    procedure UpdateTexts;
    procedure OnLanguageChanged(Sender: TObject);
    procedure ShowWelcome;
  public
    procedure Configure(ASession: TSessionService; AUser: TUser;
      ALocalization: TLocalizationService;
      ALoginPreferences: ILoginPreferences;
      AUserMgmt: TUserManagementService);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  NAV_INICIO = 0;
  NAV_USUARIOS = 1;
  NAV_PREFERENCIAS = 2;

procedure TFrmMain.Configure(ASession: TSessionService; AUser: TUser;
  ALocalization: TLocalizationService;
  ALoginPreferences: ILoginPreferences;
  AUserMgmt: TUserManagementService);
begin
  FSession := ASession;
  FLoggedInUser := AUser;
  FLocalization := ALocalization;
  FLoginPreferences := ALoginPreferences;
  FUserMgmt := AUserMgmt;

  LstNav.Items.Clear;
  LstNav.Items.Add(FLocalization.GetString('nav_inicio'));
  LstNav.Items.Add(FLocalization.GetString('nav_usuarios'));
  LstNav.Items.Add(FLocalization.GetString('nav_preferencias'));

  if (FUserMgmt = nil) or (not FUserMgmt.CanManage) then
    LstNav.Items.Delete(NAV_USUARIOS);

  FramePreferences := nil;
  FrameUserAdmin := nil;

  UpdateTexts;
  LstNav.ItemIndex := NAV_INICIO;
  ShowWelcome;
end;

procedure TFrmMain.CreateFrames;
begin
  if FramePreferences = nil then
  begin
    FramePreferences := TFramePreferences.Create(Self);
    FramePreferences.Parent := PanelCenter;
    FramePreferences.Align := alClient;
    FramePreferences.Visible := False;
    FramePreferences.Configure(FLocalization, FLoginPreferences);
    FramePreferences.OnLanguageChanged := OnLanguageChanged;
  end;

  if (FrameUserAdmin = nil) and (FUserMgmt <> nil) and FUserMgmt.CanManage then
  begin
    FrameUserAdmin := TFrameUserAdmin.Create(Self);
    FrameUserAdmin.Parent := PanelCenter;
    FrameUserAdmin.Align := alClient;
    FrameUserAdmin.Visible := False;
    FrameUserAdmin.Configure(FUserMgmt, FLocalization);
  end;
end;

procedure TFrmMain.FreeFrames;
begin
  FramePreferences.Free;
  FramePreferences := nil;
  FrameUserAdmin.Free;
  FrameUserAdmin := nil;
end;

procedure TFrmMain.OnLanguageChanged(Sender: TObject);
begin
  UpdateTexts;
  if FrameUserAdmin <> nil then
    FrameUserAdmin.Configure(FUserMgmt, FLocalization);
end;

procedure TFrmMain.UpdateTexts;
begin
  Caption := FLocalization.GetString('app_title') + ' - ' + FLoggedInUser.Username;
  LblWelcome.Caption := FLocalization.GetString('main_welcome');
  LblRole.Caption := FLocalization.GetString('main_role_admin');
  LblWelcomeMsg.Caption := FLocalization.GetString('main_welcome') + ' ' +
    FLoggedInUser.Username;
  if FLoggedInUser.Role = urAdmin then
    LblRoleMsg.Caption := FLocalization.GetString('main_role_admin')
  else
    LblRoleMsg.Caption := FLocalization.GetString('main_role_user');
  BtnLogout.Caption := FLocalization.GetString('main_btn_logout');

  if LstNav.Items.Count >= 3 then
  begin
    LstNav.Items[NAV_INICIO] := FLocalization.GetString('nav_inicio');
    LstNav.Items[NAV_USUARIOS] := FLocalization.GetString('nav_usuarios');
    LstNav.Items[NAV_PREFERENCIAS] := FLocalization.GetString('nav_preferencias');
  end;
end;

procedure TFrmMain.ShowWelcome;
begin
  CreateFrames;
  PanelWelcome.Visible := True;
  if FramePreferences <> nil then
    FramePreferences.Visible := False;
  if FrameUserAdmin <> nil then
    FrameUserAdmin.Visible := False;
end;

procedure TFrmMain.LstNavClick(Sender: TObject);
begin
  CreateFrames;

  PanelWelcome.Visible := False;
  if FramePreferences <> nil then
    FramePreferences.Visible := False;
  if FrameUserAdmin <> nil then
    FrameUserAdmin.Visible := False;

  case LstNav.ItemIndex of
    NAV_INICIO: ShowWelcome;
    NAV_USUARIOS:
      if FrameUserAdmin <> nil then
      begin
        FrameUserAdmin.Configure(FUserMgmt, FLocalization);
        FrameUserAdmin.Visible := True;
      end;
    NAV_PREFERENCIAS:
      if FramePreferences <> nil then
        FramePreferences.Visible := True;
  end;
end;

procedure TFrmMain.BtnLogoutClick(Sender: TObject);
begin
  FreeFrames;
  FSession.EndSession;
  Close;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FSession <> nil then
    FSession.EndSession;
end;

end.
