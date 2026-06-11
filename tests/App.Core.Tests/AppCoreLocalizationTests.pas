unit AppCoreLocalizationTests;

interface

procedure RunLocalizationTests(var AFailures: Integer);

implementation

uses
  SysUtils,
  Classes,
  IniFiles,
  AppCoreLocalization;

var
  TestCount: Integer;
  FailCount: Integer;

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

procedure AssertEquals(AExpected, AActual: string; const AMessage: string); overload;
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected "' + AExpected +
    '", got "' + AActual + '".');
end;

procedure AssertEquals(AExpected, AActual: Integer; const AMessage: string); overload;
begin
  AssertTrue(AExpected = AActual, AMessage + ' Expected ' + IntToStr(AExpected) +
    ', got ' + IntToStr(AActual) + '.');
end;

procedure CreateTestLangFile(const ADir, ALocale: string;
  const AKeys, AValues: array of string);
var
  LIni: TIniFile;
  I: Integer;
begin
  ForceDirectories(ADir);
  LIni := TIniFile.Create(ADir + ALocale + '.ini');
  try
    for I := Low(AKeys) to High(AKeys) do
      LIni.WriteString('Strings', AKeys[I], AValues[I]);
  finally
    LIni.Free;
  end;
end;

procedure CleanupTestLangDir(const ADir: string);
var
  LSearch: TSearchRec;
begin
  if FindFirst(ADir + '*.*', faAnyFile, LSearch) = 0 then
  begin
    repeat
      if (LSearch.Name <> '.') and (LSearch.Name <> '..') then
        DeleteFile(ADir + LSearch.Name);
    until FindNext(LSearch) <> 0;
    FindClose(LSearch);
  end;
  RemoveDir(ADir);
end;

const
  TEST_LANG_DIR = 'test_lang\';

{ --- Tests --- }

procedure Test_Localization_LoadsSpanish;
var
  LService: TLocalizationService;
  LTempDir: string;
begin
  LTempDir := ExtractFilePath(ParamStr(0)) + TEST_LANG_DIR;
  CreateTestLangFile(LTempDir, 'es', ['greeting', 'farewell'],
    ['Hola', 'Adios']);
  LService := TLocalizationService.Create(LTempDir, 'es');
  try
    AssertEquals('Hola', LService.GetString('greeting'),
      'Should load Spanish greeting');
  finally
    LService.Free;
  end;
  CleanupTestLangDir(LTempDir);
end;

procedure Test_Localization_LoadsEnglish;
var
  LService: TLocalizationService;
  LTempDir: string;
begin
  LTempDir := ExtractFilePath(ParamStr(0)) + TEST_LANG_DIR;
  CreateTestLangFile(LTempDir, 'en', ['greeting'],
    ['Hello']);
  LService := TLocalizationService.Create(LTempDir, 'en');
  try
    AssertEquals('Hello', LService.GetString('greeting'),
      'Should load English greeting');
  finally
    LService.Free;
  end;
  CleanupTestLangDir(LTempDir);
end;

procedure Test_Localization_MissingKeyReturnsKey;
var
  LService: TLocalizationService;
  LTempDir: string;
begin
  LTempDir := ExtractFilePath(ParamStr(0)) + TEST_LANG_DIR;
  CreateTestLangFile(LTempDir, 'es', ['existing'], ['value']);
  LService := TLocalizationService.Create(LTempDir, 'es');
  try
    AssertEquals('nonexistent', LService.GetString('nonexistent'),
      'Missing key should return key name');
  finally
    LService.Free;
  end;
  CleanupTestLangDir(LTempDir);
end;

procedure Test_Localization_ChangeLocale;
var
  LService: TLocalizationService;
  LTempDir: string;
begin
  LTempDir := ExtractFilePath(ParamStr(0)) + TEST_LANG_DIR;
  CreateTestLangFile(LTempDir, 'es', ['greeting'], ['Hola']);
  CreateTestLangFile(LTempDir, 'en', ['greeting'], ['Hello']);
  LService := TLocalizationService.Create(LTempDir, 'es');
  try
    AssertEquals('Hola', LService.GetString('greeting'),
      'Should start with Spanish');
    LService.Locale := 'en';
    AssertEquals('Hello', LService.GetString('greeting'),
      'Should switch to English');
  finally
    LService.Free;
  end;
  CleanupTestLangDir(LTempDir);
end;

procedure Test_Localization_DefaultLocaleProperty;
var
  LService: TLocalizationService;
  LTempDir: string;
begin
  LTempDir := ExtractFilePath(ParamStr(0)) + TEST_LANG_DIR;
  LService := TLocalizationService.Create(LTempDir, 'fr');
  try
    AssertEquals('fr', LService.Locale,
      'Locale property should return constructor value');
  finally
    LService.Free;
  end;
  CleanupTestLangDir(LTempDir);
end;

{ --- Runner --- }

procedure RunLocalizationTests(var AFailures: Integer);
begin
  TestCount := 0;
  FailCount := 0;

  Writeln('--- Localization Tests ---');

  Test_Localization_LoadsSpanish;
  Test_Localization_LoadsEnglish;
  Test_Localization_MissingKeyReturnsKey;
  Test_Localization_ChangeLocale;
  Test_Localization_DefaultLocaleProperty;

  if FailCount = 0 then
    Writeln('All localization tests passed.')
  else
    Writeln(IntToStr(FailCount) + '/' + IntToStr(TestCount) +
      ' test(s) failed.');

  AFailures := AFailures + FailCount;
end;

end.
