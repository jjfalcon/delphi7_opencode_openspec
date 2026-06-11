unit LoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  AppCoreUser, AppCoreUserRepository, AppCoreAuth, AppCoreClock,
  AppCorePreferences, AppCoreLocalization;

type
  TFrmLogin = class(TForm)
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    LblUsername: TLabel;
    LblPassword: TLabel;
    BtnLogin: TButton;
    BtnCancel: TButton;
    LblError: TLabel;
    procedure BtnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuthService: TAuthService;
    FSessionService: TSessionService;
    FPermissionService: TPermissionService;
    FLoginPreferences: ILoginPreferences;
    FPasswordHasher: IPasswordHasher;
    FUserRepository: IUserRepository;
    FLocalization: TLocalizationService;
    FLastUsername: string;
    procedure UpdateTexts;
  public
    procedure Configure(AUserRepository: IUserRepository;
      ALocalization: TLocalizationService);
    property SessionService: TSessionService read FSessionService;
    property PermissionService: TPermissionService read FPermissionService;
    property LoggedInUserId: string read FLastUsername;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.Configure(AUserRepository: IUserRepository;
  ALocalization: TLocalizationService);
var
  LClock: IClock;
begin
  FUserRepository := AUserRepository;
  FLocalization := ALocalization;
  FPasswordHasher := TBasicPasswordHasher.Create;
  FAuthService := TAuthService.Create(FUserRepository, FPasswordHasher, 3);
  LClock := TSystemClock.Create;
  FSessionService := TSessionService.Create(LClock, 5);
  FPermissionService := TPermissionService.Create(FSessionService);
  FLoginPreferences := TLoginPreferences.Create(
    ExtractFilePath(Application.ExeName) + 'app.config');
  UpdateTexts;
end;

procedure TFrmLogin.UpdateTexts;
begin
  Caption := FLocalization.GetString('login_title');
  LblUsername.Caption := FLocalization.GetString('login_username');
  LblPassword.Caption := FLocalization.GetString('login_password');
  BtnLogin.Caption := FLocalization.GetString('login_btn_login');
  BtnCancel.Caption := FLocalization.GetString('login_btn_cancel');
  LblError.Caption := '';
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  LblError.Caption := '';
  EdtUsername.Text := '';
  EdtPassword.Text := '';
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
var
  LUser: TUser;
  LResult: TLoginResult;
begin
  LblError.Caption := '';

  LResult := FAuthService.Login(EdtUsername.Text, EdtPassword.Text, LUser);

  case LResult of
    lrSuccess:
      begin
        FSessionService.StartSession(LUser);
        FLastUsername := LUser.Username;
        FLoginPreferences.SaveLastUsername(LUser.Username);
        ModalResult := mrOk;
      end;
    lrInvalidCredentials:
      LblError.Caption := FLocalization.GetString('login_invalid_credentials');
    lrAccountLocked:
      LblError.Caption := FLocalization.GetString('login_account_locked');
    lrUsernameRequired:
      LblError.Caption := FLocalization.GetString('login_username_required');
    lrPasswordRequired:
      LblError.Caption := FLocalization.GetString('login_password_required');
  end;
end;

end.
