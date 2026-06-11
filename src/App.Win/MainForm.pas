unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  AppCoreUser, AppCoreAuth, AppCoreLocalization, AppCorePreferences;

type
  TFrmMain = class(TForm)
    LblWelcome: TLabel;
    LblRole: TLabel;
    BtnLogout: TButton;
    LblLang: TLabel;
    CboLang: TComboBox;
    procedure BtnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CboLangChange(Sender: TObject);
  private
    FSession: TSessionService;
    FLoggedInUser: TUser;
    FLocalization: TLocalizationService;
    FLoginPreferences: ILoginPreferences;
    procedure UpdateTexts;
  public
    procedure Configure(ASession: TSessionService; AUser: TUser;
      ALocalization: TLocalizationService;
      ALoginPreferences: ILoginPreferences);
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  LANG_DISPLAY: array[0..1] of string = ('Espa'#241'ol', 'English');
  LANG_LOCALES: array[0..1] of string = ('es', 'en');

procedure TFrmMain.Configure(ASession: TSessionService; AUser: TUser;
  ALocalization: TLocalizationService;
  ALoginPreferences: ILoginPreferences);
var
  I: Integer;
begin
  FSession := ASession;
  FLoggedInUser := AUser;
  FLocalization := ALocalization;
  FLoginPreferences := ALoginPreferences;

  for I := 0 to 1 do
    CboLang.Items.Add(LANG_DISPLAY[I]);
  if FLocalization.Locale = 'en' then
    CboLang.ItemIndex := 1
  else
    CboLang.ItemIndex := 0;

  UpdateTexts;
end;

procedure TFrmMain.UpdateTexts;
begin
  Caption := FLocalization.GetString('app_title') + ' - ' + FLoggedInUser.Username;
  LblWelcome.Caption := FLocalization.GetString('main_welcome') + ' ' +
    FLoggedInUser.Username;
  if FLoggedInUser.Role = urAdmin then
    LblRole.Caption := FLocalization.GetString('main_role_admin')
  else
    LblRole.Caption := FLocalization.GetString('main_role_user');
  BtnLogout.Caption := FLocalization.GetString('main_btn_logout');
  LblLang.Caption := FLocalization.GetString('main_language');
end;

procedure TFrmMain.CboLangChange(Sender: TObject);
begin
  if CboLang.ItemIndex >= 0 then
  begin
    FLocalization.Locale := LANG_LOCALES[CboLang.ItemIndex];
    UpdateTexts;
    FLoginPreferences.SaveLanguage(FLocalization.Locale);
  end;
end;

procedure TFrmMain.BtnLogoutClick(Sender: TObject);
begin
  FSession.EndSession;
  Close;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FSession <> nil then
    FSession.EndSession;
end;

end.
