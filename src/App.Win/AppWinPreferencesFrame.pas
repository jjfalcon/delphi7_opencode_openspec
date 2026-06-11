unit AppWinPreferencesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  AppCoreLocalization, AppCorePreferences;

type
  TFramePreferences = class(TFrame)
    LblLang: TLabel;
    CboLang: TComboBox;
    LblPersistence: TLabel;
    CboPersistence: TComboBox;
    procedure CboLangChange(Sender: TObject);
    procedure CboPersistenceChange(Sender: TObject);
  private
    FLocalization: TLocalizationService;
    FLoginPreferences: ILoginPreferences;
    FOnLanguageChanged: TNotifyEvent;
    procedure UpdateTexts;
  public
    procedure Configure(ALocalization: TLocalizationService;
      ALoginPreferences: ILoginPreferences);
    property OnLanguageChanged: TNotifyEvent read FOnLanguageChanged
      write FOnLanguageChanged;
  end;

implementation

{$R *.dfm}

const
  LANG_DISPLAY: array[0..1] of string = ('Espa'#241'ol', 'English');
  LANG_LOCALES: array[0..1] of string = ('es', 'en');
  REPO_DISPLAY: array[0..1] of string = ('Memoria', 'JSON');
  REPO_VALUES: array[0..1] of string = ('memory', 'file');

procedure TFramePreferences.Configure(ALocalization: TLocalizationService;
  ALoginPreferences: ILoginPreferences);
var
  I: Integer;
begin
  FLocalization := ALocalization;
  FLoginPreferences := ALoginPreferences;

  CboLang.Items.Clear;
  CboPersistence.Items.Clear;
  for I := 0 to 1 do
  begin
    CboLang.Items.Add(LANG_DISPLAY[I]);
    CboPersistence.Items.Add(REPO_DISPLAY[I]);
  end;
  if FLocalization.Locale = 'en' then
    CboLang.ItemIndex := 1
  else
    CboLang.ItemIndex := 0;

  if FLoginPreferences.LoadRepositoryType = 'file' then
    CboPersistence.ItemIndex := 1
  else
    CboPersistence.ItemIndex := 0;

  UpdateTexts;
end;

procedure TFramePreferences.UpdateTexts;
begin
  LblLang.Caption := FLocalization.GetString('main_language');
  LblPersistence.Caption := FLocalization.GetString('main_persistence');
end;

procedure TFramePreferences.CboLangChange(Sender: TObject);
begin
  if CboLang.ItemIndex >= 0 then
  begin
    FLocalization.Locale := LANG_LOCALES[CboLang.ItemIndex];
    UpdateTexts;
    FLoginPreferences.SaveLanguage(FLocalization.Locale);
    if Assigned(FOnLanguageChanged) then
      FOnLanguageChanged(Self);
  end;
end;

procedure TFramePreferences.CboPersistenceChange(Sender: TObject);
begin
  if CboPersistence.ItemIndex >= 0 then
    FLoginPreferences.SaveRepositoryType(
      REPO_VALUES[CboPersistence.ItemIndex]);
end;

end.
