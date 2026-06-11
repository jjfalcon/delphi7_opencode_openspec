program WindowsApp;

uses
  Forms,
  SysUtils,
  Dialogs,
  Classes,
  Controls,
  ActiveX,
  LoginForm in 'LoginForm.pas' {FrmLogin},
  MainForm in 'MainForm.pas' {FrmMain},
  PreferencesFrame in 'PreferencesFrame.pas' {FramePreferences: TFrame},
  UserAdminFrame in 'UserAdminFrame.pas' {FrameUserAdmin: TFrame},
  AppCoreUser in '..\App.Core\AppCoreUser.pas',
  AppCoreUserRepository in '..\App.Core\AppCoreUserRepository.pas',
  AppCoreAuth in '..\App.Core\AppCoreAuth.pas',
  AppCoreClock in '..\App.Core\AppCoreClock.pas',
  AppCorePreferences in '..\App.Core\AppCorePreferences.pas',
  AppCoreLocalization in '..\App.Core\AppCoreLocalization.pas',
  AppCoreUserManagement in '..\App.Core\AppCoreUserManagement.pas',
  AppCoreRepositoryFactory in '..\App.Core\AppCoreRepositoryFactory.pas',
  AppCoreFileUserRepository in '..\App.Core\AppCoreFileUserRepository.pas',
  AppCoreUtils in '..\App.Core\AppCoreUtils.pas';

var
  LFormLogin: TFrmLogin;
  LFormMain: TFrmMain;
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
//  CoInitializeEx(nil, COINIT_MULTITHREADED);
  Application.Initialize;
  Application.Title := 'SDD OpenSpec App';

  LConfigPath := ExtractFilePath(Application.ExeName) + 'app.config';
  LUserRepo := TRepositoryFactory.CreateRepository(LConfigPath);
  LHasher := TBasicPasswordHasher.Create;

  if LUserRepo.FindByUsername('admin') = nil then
  begin
    LAdmin := TUser.Create('', 'admin', urAdmin);
    LAdmin.PasswordSalt := LHasher.GenerateSalt;
    LAdmin.PasswordHash := LHasher.Hash('admin', LAdmin.PasswordSalt);
    LUserRepo.Add(LAdmin);
  end;

  LLangPath := ExtractFilePath(Application.ExeName) + 'lang\';
  LLoginPrefs := TLoginPreferences.Create(LConfigPath);
  LDefaultLocale := LLoginPrefs.LoadLanguage;
  LLocalization := TLocalizationService.Create(LLangPath, LDefaultLocale);

  LFormLogin := TFrmLogin.Create(Application);
  try
    LFormLogin.Configure(LUserRepo, LLocalization);

    if LFormLogin.ShowModal = mrOk then
    begin
      LPermService := TPermissionService.Create(LFormLogin.SessionService);
      LUserMgmt := TUserManagementService.Create(LUserRepo, LHasher,
        LPermService);

      Application.CreateForm(TFrmMain, LFormMain);
      LFormMain.Configure(LFormLogin.SessionService,
        LFormLogin.SessionService.LoggedInUser, LLocalization, LLoginPrefs,
        LUserMgmt);
      LFormLogin.Free;
      LFormLogin := nil;
      Application.Run;
    end;
  finally
    if LFormLogin <> nil then
      LFormLogin.Free;
    LLocalization.Free;
  end;
end.
