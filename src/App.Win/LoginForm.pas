unit LoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  AppCoreUser, AppCoreUserRepository, AppCoreAuth, AppCoreClock,
  AppCorePreferences;

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
    FLastUsername: string;
  public
    procedure Configure(AUserRepository: IUserRepository);
    property SessionService: TSessionService read FSessionService;
    property PermissionService: TPermissionService read FPermissionService;
    property LoggedInUserId: string read FLastUsername;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.Configure(AUserRepository: IUserRepository);
var
  LClock: IClock;
begin
  FUserRepository := AUserRepository;
  FPasswordHasher := TBasicPasswordHasher.Create;
  FAuthService := TAuthService.Create(FUserRepository, FPasswordHasher, 3);
  LClock := TSystemClock.Create;
  FSessionService := TSessionService.Create(LClock, 5);
  FPermissionService := TPermissionService.Create(FSessionService);
  FLoginPreferences := TLoginPreferences.Create(
    ExtractFilePath(Application.ExeName) + 'app.config');
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
      LblError.Caption := 'Usuario o contraseña incorrectos';
    lrAccountLocked:
      LblError.Caption := 'Cuenta bloqueada. Contacte al administrador.';
    lrUsernameRequired:
      LblError.Caption := 'El usuario es obligatorio';
    lrPasswordRequired:
      LblError.Caption := 'La contraseña es obligatoria';
  end;
end;

end.
