program WindowsApp;

uses
  Forms,
  SysUtils,
  Dialogs,
  Classes,
  IniFiles,
  Controls,
  ActiveX,
  LoginForm in 'LoginForm.pas' {FrmLogin},
  MainForm in 'MainForm.pas' {FrmMain},
  AppCoreUser in '..\App.Core\AppCoreUser.pas',
  AppCoreUserRepository in '..\App.Core\AppCoreUserRepository.pas',
  AppCoreAuth in '..\App.Core\AppCoreAuth.pas',
  AppCoreClock in '..\App.Core\AppCoreClock.pas',
  AppCorePreferences in '..\App.Core\AppCorePreferences.pas';

var
  LUserRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAdmin: TUser;
begin
  CoInitializeEx(nil, COINIT_MULTITHREADED);
  Application.Initialize;
  Application.Title := 'SDD OpenSpec App';

  LUserRepo := TInMemoryUserRepository.Create;
  LHasher := TBasicPasswordHasher.Create;

  if LUserRepo.FindByUsername('admin') = nil then
  begin
    LAdmin := TUser.Create('', 'admin', urAdmin);
    LAdmin.PasswordSalt := LHasher.GenerateSalt;
    LAdmin.PasswordHash := LHasher.Hash('admin', LAdmin.PasswordSalt);
    LUserRepo.Save(LAdmin);
  end;

  FrmLogin := TFrmLogin.Create(Application);
  try
    FrmLogin.Configure(LUserRepo);

    if FrmLogin.ShowModal = mrOk then
    begin
      Application.CreateForm(TFrmMain, FrmMain);
      FrmMain.Configure(FrmLogin.SessionService,
        FrmLogin.SessionService.LoggedInUser);
      FrmLogin.Free;
      FrmLogin := nil;
      Application.Run;
    end;
  finally
    if FrmLogin <> nil then
      FrmLogin.Free;
  end;
end.
