program AppCoreTests;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  IniFiles,
  ActiveX,
  AppCoreAuthServiceTests in 'AppCoreAuthServiceTests.pas',
  AppCoreUser in '..\..\src\App.Core\AppCoreUser.pas',
  AppCoreUserRepository in '..\..\src\App.Core\AppCoreUserRepository.pas',
  AppCoreAuth in '..\..\src\App.Core\AppCoreAuth.pas',
  AppCoreClock in '..\..\src\App.Core\AppCoreClock.pas',
  AppCorePreferences in '..\..\src\App.Core\AppCorePreferences.pas';

var
  Failures: Integer;
begin
  CoInitializeEx(nil, COINIT_MULTITHREADED);
  Randomize;
  Failures := 0;

  try
    RunAuthServiceTests(Failures);

    if Failures = 0 then
      Writeln('All tests passed.')
    else
      Writeln(IntToStr(Failures) + ' test(s) failed.');
    Readln;
    if Failures <> 0 then
      Halt(1);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.
