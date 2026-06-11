unit AppCoreLocalization;

interface

uses
  SysUtils,
  IniFiles;

type
  TLocalizationService = class
  private
    FLangDir: string;
    FLocale: string;
  public
    constructor Create(const ALangDir, ALocale: string);
    function GetString(const AKey: string): string;
    property Locale: string read FLocale write FLocale;
  end;

implementation

constructor TLocalizationService.Create(const ALangDir, ALocale: string);
begin
  inherited Create;
  FLangDir := IncludeTrailingPathDelimiter(ALangDir);
  FLocale := ALocale;
end;

function TLocalizationService.GetString(const AKey: string): string;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FLangDir + FLocale + '.ini');
  try
    Result := LIni.ReadString('Strings', AKey, AKey);
  finally
    LIni.Free;
  end;
end;

end.
