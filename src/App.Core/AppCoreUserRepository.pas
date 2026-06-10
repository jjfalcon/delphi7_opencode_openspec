unit AppCoreUserRepository;

interface

uses
  Classes,
  AppCoreUser;

type
  IUserRepository = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function FindById(const AId: string): TUser;
    function FindByUsername(const AUsername: string): TUser;
    function FindAll: TList;
    procedure Save(AUser: TUser);
    procedure Delete(const AId: string);
  end;

  TInMemoryUserRepository = class(TInterfacedObject, IUserRepository)
  private
    FItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function FindById(const AId: string): TUser;
    function FindByUsername(const AUsername: string): TUser;
    function FindAll: TList;
    procedure Save(AUser: TUser);
    procedure Delete(const AId: string);
  end;

implementation

uses
  SysUtils,
  ActiveX;

function NewGuidString: string;
var
  LGuid: TGuid;
begin
  if CoCreateGuid(LGuid) = S_OK then
    Result := GuidToString(LGuid)
  else
    Result := '';
end;

constructor TInMemoryUserRepository.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TInMemoryUserRepository.Destroy;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TUser(FItems[I]).Free;
  FItems.Free;
  inherited;
end;

function TInMemoryUserRepository.FindById(const AId: string): TUser;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
  begin
    Result := TUser(FItems[I]);
    if Result.Id = AId then
      Exit;
  end;
  Result := nil;
end;

function TInMemoryUserRepository.FindByUsername(const AUsername: string): TUser;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
  begin
    Result := TUser(FItems[I]);
    if CompareText(Result.Username, AUsername) = 0 then
      Exit;
  end;
  Result := nil;
end;

function TInMemoryUserRepository.FindAll: TList;
begin
  Result := FItems;
end;

procedure TInMemoryUserRepository.Save(AUser: TUser);
var
  LExisting: TUser;
begin
  if AUser.Id = '' then
    AUser.Id := NewGuidString;
  LExisting := FindById(AUser.Id);
  if LExisting <> nil then
  begin
    LExisting.Username := AUser.Username;
    LExisting.PasswordHash := AUser.PasswordHash;
    LExisting.PasswordSalt := AUser.PasswordSalt;
    LExisting.Role := AUser.Role;
    LExisting.IsLocked := AUser.IsLocked;
    LExisting.FailedLoginAttempts := AUser.FailedLoginAttempts;
    AUser.Free;
  end
  else
    FItems.Add(AUser);
end;

procedure TInMemoryUserRepository.Delete(const AId: string);
var
  LUser: TUser;
begin
  LUser := FindById(AId);
  if LUser <> nil then
  begin
    FItems.Remove(LUser);
    LUser.Free;
  end;
end;

end.
