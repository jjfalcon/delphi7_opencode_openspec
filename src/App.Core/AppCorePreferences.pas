unit AppCorePreferences;

interface

type
  ILoginPreferences = interface
    ['{33333333-4444-5555-6666-777777777777}']
    function LoadLastUsername: string;
    procedure SaveLastUsername(const AUsername: string);
    function LoadLanguage: string;
    procedure SaveLanguage(const ALocale: string);
    function LoadRepositoryType: string;
    procedure SaveRepositoryType(const ARepoType: string);
  end;

  TLoginPreferences = class(TInterfacedObject, ILoginPreferences)
  private
    FConfigPath: string;
  public
    constructor Create(const AConfigPath: string);
    function LoadLastUsername: string;
    procedure SaveLastUsername(const AUsername: string);
    function LoadLanguage: string;
    procedure SaveLanguage(const ALocale: string);
    function LoadRepositoryType: string;
    procedure SaveRepositoryType(const ARepoType: string);
  end;

implementation

uses
  SysUtils,
  IniFiles;

constructor TLoginPreferences.Create(const AConfigPath: string);
begin
  inherited Create;
  FConfigPath := AConfigPath;
end;

function TLoginPreferences.LoadLastUsername: string;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    Result := LIni.ReadString('Login', 'LastUsername', '');
  finally
    LIni.Free;
  end;
end;

function TLoginPreferences.LoadLanguage: string;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    Result := LIni.ReadString('Language', 'Default', 'es');
  finally
    LIni.Free;
  end;
end;

procedure TLoginPreferences.SaveLanguage(const ALocale: string);
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    LIni.WriteString('Language', 'Default', ALocale);
  finally
    LIni.Free;
  end;
end;

procedure TLoginPreferences.SaveLastUsername(const AUsername: string);
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    LIni.WriteString('Login', 'LastUsername', AUsername);
  finally
    LIni.Free;
  end;
end;

function TLoginPreferences.LoadRepositoryType: string;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    Result := LIni.ReadString('Repository', 'Type', 'memory');
  finally
    LIni.Free;
  end;
end;

procedure TLoginPreferences.SaveRepositoryType(const ARepoType: string);
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FConfigPath);
  try
    LIni.WriteString('Repository', 'Type', ARepoType);
  finally
    LIni.Free;
  end;
end;

end.
