unit AppCoreUser;

interface

type
  TUserRole = (urAdmin, urUser);

  TUser = class
  private
    FId: string;
    FUsername: string;
    FPasswordHash: string;
    FPasswordSalt: string;
    FRole: TUserRole;
    FIsLocked: Boolean;
    FFailedLoginAttempts: Integer;
  public
    constructor Create(const AId, AUsername: string; const ARole: TUserRole);
    property Id: string read FId write FId;
    property Username: string read FUsername write FUsername;
    property PasswordHash: string read FPasswordHash write FPasswordHash;
    property PasswordSalt: string read FPasswordSalt write FPasswordSalt;
    property Role: TUserRole read FRole write FRole;
    property IsLocked: Boolean read FIsLocked write FIsLocked;
    property FailedLoginAttempts: Integer read FFailedLoginAttempts write FFailedLoginAttempts;
  end;

implementation

constructor TUser.Create(const AId, AUsername: string; const ARole: TUserRole);
begin
  inherited Create;
  FId := AId;
  FUsername := AUsername;
  FRole := ARole;
  FIsLocked := False;
  FFailedLoginAttempts := 0;
end;

end.
