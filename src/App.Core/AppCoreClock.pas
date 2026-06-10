unit AppCoreClock;

interface

type
  IClock = interface
    ['{11111111-2222-3333-4444-555555555555}']
    function Now: TDateTime;
  end;

  TSystemClock = class(TInterfacedObject, IClock)
    function Now: TDateTime;
  end;

implementation

uses
  SysUtils;

function TSystemClock.Now: TDateTime;
begin
  Result := SysUtils.Now;
end;

end.
