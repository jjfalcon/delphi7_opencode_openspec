unit AppCoreFileUserRepository;

interface

uses
  Classes,
  AppCoreUser,
  AppCoreUserRepository;

type
  TFileUserRepository = class(TBaseUserRepository)
  private
    FDataPath: string;
    FConfigDir: string;
    procedure LoadFromFile;
    procedure SaveToFile;
    function GetDataDir: string;
    function ReadEntireFile(const APath: string): string;
    function ExtractUsersArray(const AFullText: string): string;
    function ParseUserBlock(const ABlock: string): TUser;
  protected
    procedure DoAfterSave; override;
    procedure DoAfterDelete; override;
  public
    constructor Create(const AConfigPath: string);
  end;

implementation

uses
  SysUtils,
  AppCoreUtils;

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
  FConfigDir := ExtractFilePath(AConfigPath);
  FDataPath := GetDataDir + 'users.json';
  ForceDirectories(GetDataDir);
  LoadFromFile;
end;

function TFileUserRepository.GetDataDir: string;
begin
  Result := FConfigDir + 'data' + PathDelim;
end;

procedure TFileUserRepository.DoAfterSave;
begin
  SaveToFile;
end;

procedure TFileUserRepository.DoAfterDelete;
begin
  SaveToFile;
end;

function TFileUserRepository.ReadEntireFile(const APath: string): string;
var
  LFile: TextFile;
  LLine: string;
begin
  Result := '';
  AssignFile(LFile, APath);
  try
    Reset(LFile);
    while not Eof(LFile) do
    begin
      Readln(LFile, LLine);
      Result := Result + LLine;
    end;
  finally
    CloseFile(LFile);
  end;
end;

function TFileUserRepository.ExtractUsersArray(
  const AFullText: string): string;
var
  LPos: Integer;
begin
  Result := '';
  LPos := Pos('"users"', AFullText);
  if LPos = 0 then
    Exit;
  LPos := PosEx('[', AFullText, LPos);
  if LPos = 0 then
    Exit;
  Result := Copy(AFullText, LPos + 1, Length(AFullText));
  LPos := Pos(']', Result);
  if LPos > 0 then
    Result := Copy(Result, 1, LPos - 1);
  Result := Trim(Result);
end;

function TFileUserRepository.ParseUserBlock(const ABlock: string): TUser;
var
  LId, LUsername, LHash, LSalt, LRoleVal: string;
  LRoles: TUserRole;
  LIsLocked: Boolean;
  LFailed: Integer;
begin
  Result := nil;
  LId := ExtractJSONStr(ABlock, '"id":');
  LUsername := ExtractJSONStr(ABlock, '"username":');
  if (LId = '') or (LUsername = '') then
    Exit;
  LHash := ExtractJSONStr(ABlock, '"passwordHash":');
  LSalt := ExtractJSONStr(ABlock, '"passwordSalt":');
  LRoleVal := ExtractJSONStr(ABlock, '"role":');
  LIsLocked := ExtractJSONStr(ABlock, '"isLocked":') = 'true';
  LFailed := StrToIntDef(ExtractJSONStr(ABlock, '"failedAttempts":'), 0);
  if LRoleVal = 'admin' then
    LRoles := urAdmin
  else
    LRoles := urUser;
  Result := TUser.Create(LId, LUsername, LRoles);
  Result.PasswordHash := LHash;
  Result.PasswordSalt := LSalt;
  Result.IsLocked := LIsLocked;
  Result.FailedLoginAttempts := LFailed;
end;

procedure TFileUserRepository.LoadFromFile;
var
  LFullText: string;
  LContent: string;
  LPos: Integer;
  LEnd: Integer;
  LBlock: string;
  LUser: TUser;
begin
  if not FileExists(FDataPath) then
    Exit;

  LFullText := ReadEntireFile(FDataPath);
  LContent := ExtractUsersArray(LFullText);
  if LContent = '' then
    Exit;

  LPos := 1;
  while LPos <= Length(LContent) do
  begin
    LPos := PosEx('{', LContent, LPos);
    if LPos = 0 then
      Break;
    Inc(LPos);

    LEnd := LPos;
    while LEnd <= Length(LContent) do
    begin
      if LContent[LEnd] = '"' then
      begin
        Inc(LEnd);
        while LEnd <= Length(LContent) do
        begin
          if LContent[LEnd] = '\' then
            Inc(LEnd, 2)
          else if LContent[LEnd] = '"' then
            Break
          else
            Inc(LEnd);
        end;
      end
      else if LContent[LEnd] = '}' then
        Break;
      Inc(LEnd);
    end;

    LBlock := Copy(LContent, LPos, LEnd - LPos);
    LPos := LEnd + 1;
    LBlock := Trim(LBlock);
    if LBlock = '' then
      Continue;

    LUser := ParseUserBlock(LBlock);
    if LUser <> nil then
      FItems.Add(LUser);
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
