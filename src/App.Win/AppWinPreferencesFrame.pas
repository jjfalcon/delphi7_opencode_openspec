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
    procedure CboLangChange(Sender: TObject);
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

procedure TFramePreferences.Configure(ALocalization: TLocalizationService;
  ALoginPreferences: ILoginPreferences);
var
  I: Integer;
begin
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

procedure TFramePreferences.UpdateTexts;
begin
  LblLang.Caption := FLocalization.GetString('main_language');
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

end.
