unit AppCoreFileUserRepository;

interface

uses
  Classes,
  AppCoreUser,
  AppCoreUserRepository;

type
  TFileUserRepository = class(TInterfacedObject, IUserRepository)
  private
    FItems: TList;
    FDataPath: string;
    FConfigDir: string;
    procedure LoadFromFile;
    procedure SaveToFile;
    function GetDataDir: string;
  public
    constructor Create(const AConfigPath: string);
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

function EscapeJSON(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
  begin
    if AValue[I] = '"' then
      Result := Result + '\"'
    else if AValue[I] = '\' then
      Result := Result + '\\'
    else if AValue[I] = #10 then
      Result := Result + '\n'
    else if AValue[I] = #13 then
      Result := Result + '\r'
    else
      Result := Result + AValue[I];
  end;
end;

function UnescapeJSON(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';
  I := 1;
  while I <= Length(AValue) do
  begin
    if (AValue[I] = '\') and (I < Length(AValue)) then
    begin
      if AValue[I + 1] = '"' then
        Result := Result + '"'
      else if AValue[I + 1] = '\' then
        Result := Result + '\'
      else if AValue[I + 1] = 'n' then
        Result := Result + #10
      else if AValue[I + 1] = 'r' then
        Result := Result + #13
      else
        Result := Result + AValue[I] + AValue[I + 1];
      Inc(I, 2);
    end
    else
    begin
      Result := Result + AValue[I];
      Inc(I);
    end;
  end;
end;

function ExtractJSONStr(const ALine: string;
  const AKey: string): string;
var
  LPos: Integer;
  LStart: Integer;
  LEnd: Integer;
begin
  Result := '';
  LPos := Pos(AKey, ALine);
  if LPos = 0 then
    Exit;
  LStart := LPos + Length(AKey);
  if LStart > Length(ALine) then
    Exit;
  if ALine[LStart] <> '"' then
  begin
    LEnd := LStart;
    while (LEnd <= Length(ALine)) and (ALine[LEnd] <> ',')
      and (ALine[LEnd] <> '}') and (ALine[LEnd] <> '"') do
      Inc(LEnd);
    Result := Trim(Copy(ALine, LStart, LEnd - LStart));
    Exit;
  end;
  Inc(LStart);
  LEnd := LStart;
  while LEnd <= Length(ALine) do
  begin
    if ALine[LEnd] = '\' then
    begin
      Inc(LEnd, 2);
      Continue;
    end;
    if ALine[LEnd] = '"' then
    begin
      Result := UnescapeJSON(Copy(ALine, LStart, LEnd - LStart));
      Exit;
    end;
    Inc(LEnd);
  end;
end;

constructor TFileUserRepository.Create(const AConfigPath: string);
begin
  inherited Create;
  FItems := TList.Create;
  FConfigDir := ExtractFilePath(AConfigPath);
  FDataPath := GetDataDir + 'users.json';
  ForceDirectories(GetDataDir);
  LoadFromFile;
end;

destructor TFileUserRepository.Destroy;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TUser(FItems[I]).Free;
  FItems.Free;
  inherited;
end;

function TFileUserRepository.GetDataDir: string;
begin
  Result := FConfigDir + 'data' + PathDelim;
end;

function TFileUserRepository.FindById(const AId: string): TUser;
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

function TFileUserRepository.FindByUsername(
  const AUsername: string): TUser;
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

function TFileUserRepository.FindAll: TList;
begin
  Result := FItems;
end;

procedure TFileUserRepository.Save(AUser: TUser);
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
  SaveToFile;
end;

procedure TFileUserRepository.Delete(const AId: string);
var
  LUser: TUser;
begin
  LUser := FindById(AId);
  if LUser <> nil then
  begin
    FItems.Remove(LUser);
    LUser.Free;
    SaveToFile;
  end;
end;

procedure TFileUserRepository.LoadFromFile;
var
  LFile: TextFile;
  LLine: string;
  LFullText: string;
  LPos: Integer;
  LEnd: Integer;
  LBlock: string;
  LId, LUsername, LHash, LSalt, LRoleVal: string;
  LRoles: TUserRole;
  LIsLocked: Boolean;
  LFailed: Integer;
  LUser: TUser;
begin
  if not FileExists(FDataPath) then
    Exit;

  LFullText := '';
  AssignFile(LFile, FDataPath);
  try
    Reset(LFile);
    while not Eof(LFile) do
    begin
      Readln(LFile, LLine);
      LFullText := LFullText + LLine;
    end;
  finally
    CloseFile(LFile);
  end;

  LPos := Pos('"users"', LFullText);
  if LPos = 0 then
    Exit;

  LPos := PosEx('[', LFullText, LPos);
  if LPos = 0 then
    Exit;

  LFullText := Copy(LFullText, LPos + 1, Length(LFullText));
  LPos := Pos(']', LFullText);
  if LPos > 0 then
    LFullText := Copy(LFullText, 1, LPos - 1);

  if Trim(LFullText) = '' then
    Exit;

  LPos := 1;
  while LPos <= Length(LFullText) do
  begin
    LPos := PosEx('{', LFullText, LPos);
    if LPos = 0 then
      Break;
    Inc(LPos);

    LEnd := LPos;
    while LEnd <= Length(LFullText) do
    begin
      if LFullText[LEnd] = '"' then
      begin
        Inc(LEnd);
        while LEnd <= Length(LFullText) do
        begin
          if LFullText[LEnd] = '\' then
            Inc(LEnd, 2)
          else if LFullText[LEnd] = '"' then
            Break
          else
            Inc(LEnd);
        end;
      end
      else if LFullText[LEnd] = '}' then
        Break;
      Inc(LEnd);
    end;

    LBlock := Copy(LFullText, LPos, LEnd - LPos);
    LPos := LEnd + 1;

    LBlock := Trim(LBlock);
    if LBlock = '' then
      Continue;

    LId := ExtractJSONStr(LBlock, '"id":');
    LUsername := ExtractJSONStr(LBlock, '"username":');
    LHash := ExtractJSONStr(LBlock, '"passwordHash":');
    LSalt := ExtractJSONStr(LBlock, '"passwordSalt":');
    LRoleVal := ExtractJSONStr(LBlock, '"role":');
    LIsLocked := ExtractJSONStr(LBlock, '"isLocked":') = 'true';
    LFailed := StrToIntDef(
      ExtractJSONStr(LBlock, '"failedAttempts":'), 0);

    if (LId <> '') and (LUsername <> '') then
    begin
      if LRoleVal = 'admin' then
        LRoles := urAdmin
      else
        LRoles := urUser;

      LUser := TUser.Create(LId, LUsername, LRoles);
      LUser.PasswordHash := LHash;
      LUser.PasswordSalt := LSalt;
      LUser.IsLocked := LIsLocked;
      LUser.FailedLoginAttempts := LFailed;
      FItems.Add(LUser);
    end;
  end;
end;

procedure TFileUserRepository.SaveToFile;
var
  LFile: TextFile;
  I: Integer;
  LUser: TUser;
  LRoleStr: string;
begin
  AssignFile(LFile, FDataPath);
  try
    Rewrite(LFile);
    Writeln(LFile, '{');
    Writeln(LFile, '  "users": [');
    for I := 0 to FItems.Count - 1 do
    begin
      LUser := TUser(FItems[I]);
      if LUser.Role = urAdmin then
        LRoleStr := 'admin'
      else
        LRoleStr := 'user';

      if I > 0 then
        Writeln(LFile, ',');
      Write(LFile, '    {');
      Write(LFile, '"id":"' + LUser.Id + '"');
      Write(LFile, ',"username":"' + EscapeJSON(LUser.Username) + '"');
      Write(LFile, ',"passwordHash":"' + LUser.PasswordHash + '"');
      Write(LFile, ',"passwordSalt":"' + LUser.PasswordSalt + '"');
      Write(LFile, ',"role":"' + LRoleStr + '"');
      if LUser.IsLocked then
        Write(LFile, ',"isLocked":true')
      else
        Write(LFile, ',"isLocked":false');
      Write(LFile, ',"failedAttempts":'
        + IntToStr(LUser.FailedLoginAttempts));
      Write(LFile, '}');
    end;
    Writeln(LFile);
    Writeln(LFile, '  ]');
    Write(LFile, '}');
  finally
    CloseFile(LFile);
  end;
end;

end.
