unit AppCoreTestUtils;

interface

uses
  SysUtils,
  AppCoreUser,
  AppCoreAuth,
  AppCoreClock;

var
  TestCount: Integer;
  FailCount: Integer;

procedure AssertTrue(ACondition: Boolean; const AMessage: string);
procedure AssertEquals(AExpected, AActual: string; const AMessage: string); overload;
procedure AssertEquals(AExpected, AActual: Integer; const AMessage: string); overload;

type
  TMutableClock = class(TInterfacedObject, IClock)
  private
    FNow: TDateTime;
  public
    constructor Create(const ANow: TDateTime);
    procedure AdvanceMinutes(AMinutes: Integer);
    function Now: TDateTime;
  end;

function CreateTestUser(const AId, AUsername: string; ARole: TUserRole;
  AHasher: IPasswordHasher; const APassword: string): TUser; overload;
function CreateTestUser(const AId, AUsername: string; ARole: TUserRole;
  const APassword: string): TUser; overload;

implementation

procedure AssertTrue(ACondition: Boolean; const AMessage: string);
begin
  Inc(TestCount);
  if not ACondition then
  begin
    Writeln('FAIL: ' + AMessage);
    Inc(FailCount);
  end
  else
    Writeln('PASS: ' + AMessage);
end;

procedure AssertEquals(AExpected, AActual: string; const AMessage: string);
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected "' + AExpected +
    '", got "' + AActual + '".');
end;

procedure AssertEquals(AExpected, AActual: Integer; const AMessage: string);
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected ' + IntToStr(AExpected) +
    ', got ' + IntToStr(AActual) + '.');
end;

constructor TMutableClock.Create(const ANow: TDateTime);
begin
  inherited Create;
  FNow := ANow;
end;

procedure TMutableClock.AdvanceMinutes(AMinutes: Integer);
begin
  FNow := FNow + (AMinutes / (24 * 60));
end;

function TMutableClock.Now: TDateTime;
begin
  Result := FNow;
end;

function CreateTestUser(const AId, AUsername: string; ARole: TUserRole;
  AHasher: IPasswordHasher; const APassword: string): TUser;
begin
  Result := TUser.Create(AId, AUsername, ARole);
  Result.PasswordSalt := AHasher.GenerateSalt;
  Result.PasswordHash := AHasher.Hash(APassword, Result.PasswordSalt);
end;

function CreateTestUser(const AId, AUsername: string; ARole: TUserRole;
  const APassword: string): TUser;
var
  LHasher: IPasswordHasher;
begin
  LHasher := TBasicPasswordHasher.Create;
  Result := TUser.Create(AId, AUsername, ARole);
  Result.PasswordSalt := LHasher.GenerateSalt;
  Result.PasswordHash := LHasher.Hash(APassword, Result.PasswordSalt);
end;

end.
