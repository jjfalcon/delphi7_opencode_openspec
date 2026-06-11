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
    procedure Add(AUser: TUser);
    procedure Update(AUser: TUser);
    procedure Delete(const AId: string);
  end;

  TBaseUserRepository = class(TInterfacedObject, IUserRepository)
  protected
    FItems: TList;
    procedure DoAfterSave; virtual;
    procedure DoAfterDelete; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function FindById(const AId: string): TUser;
    function FindByUsername(const AUsername: string): TUser;
    function FindAll: TList;
    procedure Add(AUser: TUser);
    procedure Update(AUser: TUser);
    procedure Delete(const AId: string);
  end;

  TInMemoryUserRepository = class(TBaseUserRepository)
  end;

implementation

uses
  SysUtils,
  AppCoreUtils;

constructor TBaseUserRepository.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TBaseUserRepository.Destroy;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TUser(FItems[I]).Free;
  FItems.Free;
  inherited;
end;

function TBaseUserRepository.FindById(const AId: string): TUser;
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

function TBaseUserRepository.FindByUsername(const AUsername: string): TUser;
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

function TBaseUserRepository.FindAll: TList;
begin
  Result := FItems;
end;

procedure TBaseUserRepository.Add(AUser: TUser);
begin
  if AUser.Id = '' then
    AUser.Id := NewGuidString;
  FItems.Add(AUser);
  DoAfterSave;
end;

procedure TBaseUserRepository.Update(AUser: TUser);
var
  LExisting: TUser;
begin
  LExisting := FindById(AUser.Id);
  if LExisting <> nil then
  begin
    LExisting.Username := AUser.Username;
    LExisting.PasswordHash := AUser.PasswordHash;
    LExisting.PasswordSalt := AUser.PasswordSalt;
    LExisting.Role := AUser.Role;
    LExisting.IsLocked := AUser.IsLocked;
    LExisting.FailedLoginAttempts := AUser.FailedLoginAttempts;
    DoAfterSave;
  end;
end;

procedure TBaseUserRepository.Delete(const AId: string);
var
  LUser: TUser;
begin
  LUser := FindById(AId);
  if LUser <> nil then
  begin
    FItems.Remove(LUser);
    LUser.Free;
    DoAfterDelete;
  end;
end;

procedure TBaseUserRepository.DoAfterSave;
begin
end;

procedure TBaseUserRepository.DoAfterDelete;
begin
end;

end.
