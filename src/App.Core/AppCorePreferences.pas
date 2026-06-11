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

const
  CSecLogin = 'Login';
  CKeyLastUsername = 'LastUsername';
  CSecLanguage = 'Language';
  CKeyDefault = 'Default';
  CSecRepository = 'Repository';
  CKeyType = 'Type';

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
    Result := LIni.ReadString(CSecLogin, CKeyLastUsername, '');
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
    Result := LIni.ReadString(CSecLanguage, CKeyDefault, 'es');
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
    LIni.WriteString(CSecLanguage, CKeyDefault, ALocale);
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
    LIni.WriteString(CSecLogin, CKeyLastUsername, AUsername);
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
    Result := LIni.ReadString(CSecRepository, CKeyType, 'memory');
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
    LIni.WriteString(CSecRepository, CKeyType, ARepoType);
  finally
    LIni.Free;
  end;
end;

end.
