unit AppCoreUtils;

interface

function NewGuidString: string;
function PosEx(const ASubStr, AStr: string; AOffset: Integer): Integer;

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
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

function PosEx(const ASubStr, AStr: string; AOffset: Integer): Integer;
var
  LWork: string;
begin
  if AOffset < 1 then
    AOffset := 1;
  LWork := Copy(AStr, AOffset, Length(AStr));
  Result := Pos(ASubStr, LWork);
  if Result > 0 then
    Result := Result + AOffset - 1;
end;

end.
