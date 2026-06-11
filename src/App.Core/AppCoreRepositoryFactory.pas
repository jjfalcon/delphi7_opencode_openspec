unit AppCoreRepositoryFactory;

interface

uses
  AppCoreUserRepository;

type
  TRepositoryFactory = class
  public
    class function CreateRepository(const AConfigPath: string): IUserRepository;
  end;

implementation

uses
  SysUtils,
  IniFiles,
  AppCoreFileUserRepository;

const
  CSecRepository = 'Repository';
  CKeyType = 'Type';

class function TRepositoryFactory.CreateRepository(
  const AConfigPath: string): IUserRepository;
var
  LIni: TIniFile;
  LRepoType: string;
begin
  LIni := TIniFile.Create(AConfigPath);
  try
    LRepoType := LowerCase(LIni.ReadString(CSecRepository, CKeyType, 'memory'));
  finally
    LIni.Free;
  end;

  if LRepoType = 'file' then
    Result := TFileUserRepository.Create(AConfigPath)
  else
    Result := TInMemoryUserRepository.Create;
end;

end.
