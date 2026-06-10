unit AppCoreAuth;

interface

uses
  AppCoreUser,
  AppCoreUserRepository,
  AppCoreClock;

type
  TLoginResult = (lrSuccess, lrInvalidCredentials, lrAccountLocked,
    lrUsernameRequired, lrPasswordRequired);

  IPasswordHasher = interface
    ['{22222222-3333-4444-5555-666666666666}']
    function Hash(const APassword, ASalt: string): string;
    function GenerateSalt: string;
  end;

  TBasicPasswordHasher = class(TInterfacedObject, IPasswordHasher)
    function Hash(const APassword, ASalt: string): string;
    function GenerateSalt: string;
  end;

  TAuthService = class
  private
    FUserRepository: IUserRepository;
    FPasswordHasher: IPasswordHasher;
    FMaxFailedAttempts: Integer;
  public
    constructor Create(AUserRepository: IUserRepository;
      APasswordHasher: IPasswordHasher; AMaxFailedAttempts: Integer);
    function Login(const AUsername, APassword: string;
      out AUser: TUser): TLoginResult;
  end;

  TSessionService = class
  private
    FLoggedInUser: TUser;
    FLastActivity: TDateTime;
    FClock: IClock;
    FTimeoutMinutes: Integer;
  public
    constructor Create(AClock: IClock; ATimeoutMinutes: Integer);
    procedure StartSession(AUser: TUser);
    procedure Touch;
    function IsActive: Boolean;
    procedure EndSession;
    function LoggedInUser: TUser;
  end;

  TPermissionService = class
  private
    FSession: TSessionService;
  public
    constructor Create(ASession: TSessionService);
    function IsAdmin: Boolean;
    function IsLoggedIn: Boolean;
  end;

implementation

uses
  SysUtils;

{ TBasicPasswordHasher }

function TBasicPasswordHasher.Hash(const APassword, ASalt: string): string;
var
  I: Integer;
  LHash: LongWord;
begin
  LHash := 5381;
  for I := 1 to Length(APassword) do
    LHash := ((LHash shl 5) + LHash) + Ord(APassword[I]);
  for I := 1 to Length(ASalt) do
    LHash := ((LHash shl 5) + LHash) + Ord(ASalt[I]);
  Result := IntToHex(LHash, 8);
end;

function TBasicPasswordHasher.GenerateSalt: string;
begin
  Result := IntToHex(Random(MaxInt), 8);
end;

{ TAuthService }

constructor TAuthService.Create(AUserRepository: IUserRepository;
  APasswordHasher: IPasswordHasher; AMaxFailedAttempts: Integer);
begin
  inherited Create;
  FUserRepository := AUserRepository;
  FPasswordHasher := APasswordHasher;
  FMaxFailedAttempts := AMaxFailedAttempts;
end;

function TAuthService.Login(const AUsername, APassword: string;
  out AUser: TUser): TLoginResult;
var
  LUser: TUser;
begin
  AUser := nil;

  if Trim(AUsername) = '' then
  begin
    Result := lrUsernameRequired;
    Exit;
  end;

  if Trim(APassword) = '' then
  begin
    Result := lrPasswordRequired;
    Exit;
  end;

  LUser := FUserRepository.FindByUsername(Trim(AUsername));
  if LUser = nil then
  begin
    Result := lrInvalidCredentials;
    Exit;
  end;

  if LUser.IsLocked then
  begin
    Result := lrAccountLocked;
    Exit;
  end;

  if LUser.PasswordHash <> FPasswordHasher.Hash(APassword, LUser.PasswordSalt) then
  begin
    LUser.FailedLoginAttempts := LUser.FailedLoginAttempts + 1;
    if LUser.FailedLoginAttempts >= FMaxFailedAttempts then
      LUser.IsLocked := True;
    Result := lrInvalidCredentials;
    Exit;
  end;

  LUser.FailedLoginAttempts := 0;
  AUser := LUser;
  Result := lrSuccess;
end;

{ TSessionService }

constructor TSessionService.Create(AClock: IClock; ATimeoutMinutes: Integer);
begin
  inherited Create;
  FClock := AClock;
  FTimeoutMinutes := ATimeoutMinutes;
  FLoggedInUser := nil;
  FLastActivity := 0;
end;

procedure TSessionService.StartSession(AUser: TUser);
begin
  FLoggedInUser := AUser;
  FLastActivity := FClock.Now;
end;

procedure TSessionService.Touch;
begin
  FLastActivity := FClock.Now;
end;

function TSessionService.IsActive: Boolean;
begin
  Result := (FLoggedInUser <> nil) and
    ((FClock.Now - FLastActivity) * 24 * 60 < FTimeoutMinutes);
end;

procedure TSessionService.EndSession;
begin
  FLoggedInUser := nil;
  FLastActivity := 0;
end;

function TSessionService.LoggedInUser: TUser;
begin
  Result := FLoggedInUser;
end;

{ TPermissionService }

constructor TPermissionService.Create(ASession: TSessionService);
begin
  inherited Create;
  FSession := ASession;
end;

function TPermissionService.IsAdmin: Boolean;
begin
  Result := FSession.IsActive and
    (FSession.LoggedInUser <> nil) and
    (FSession.LoggedInUser.Role = urAdmin);
end;

function TPermissionService.IsLoggedIn: Boolean;
begin
  Result := FSession.IsActive;
end;

end.
