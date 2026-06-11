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
  AppWinPreferencesFrame in 'AppWinPreferencesFrame.pas' {FramePreferences: TFrame},
  AppWinUserAdminFrame in 'AppWinUserAdminFrame.pas' {FrameUserAdmin: TFrame},
  AppCoreUser in '..\App.Core\AppCoreUser.pas',
  AppCoreUserRepository in '..\App.Core\AppCoreUserRepository.pas',
  AppCoreAuth in '..\App.Core\AppCoreAuth.pas',
  AppCoreClock in '..\App.Core\AppCoreClock.pas',
  AppCorePreferences in '..\App.Core\AppCorePreferences.pas',
  AppCoreLocalization in '..\App.Core\AppCoreLocalization.pas',
  AppCoreUserManagement in '..\App.Core\AppCoreUserManagement.pas';

var
  LUserRepo: IUserRepository;
  LHasher: IPasswordHasher;
  LAdmin: TUser;
  LConfigPath: string;
  LLangPath: string;
  LDefaultLocale: string;
  LLoginPrefs: ILoginPreferences;
  LLocalization: TLocalizationService;
  LPermService: TPermissionService;
  LUserMgmt: TUserManagementService;
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

  LConfigPath := ExtractFilePath(Application.ExeName) + 'app.config';
  LLangPath := ExtractFilePath(Application.ExeName) + 'lang\';
  LLoginPrefs := TLoginPreferences.Create(LConfigPath);
  LDefaultLocale := LLoginPrefs.LoadLanguage;
  LLocalization := TLocalizationService.Create(LLangPath, LDefaultLocale);

  FrmLogin := TFrmLogin.Create(Application);
  try
    FrmLogin.Configure(LUserRepo, LLocalization);

    if FrmLogin.ShowModal = mrOk then
    begin
      LPermService := TPermissionService.Create(FrmLogin.SessionService);
      LUserMgmt := TUserManagementService.Create(LUserRepo, LHasher,
        LPermService);

      Application.CreateForm(TFrmMain, FrmMain);
      FrmMain.Configure(FrmLogin.SessionService,
        FrmLogin.SessionService.LoggedInUser, LLocalization, LLoginPrefs,
        LUserMgmt);
      FrmLogin.Free;
      FrmLogin := nil;
      Application.Run;
    end;
  finally
    if FrmLogin <> nil then
      FrmLogin.Free;
    LLocalization.Free;
  end;
end.
