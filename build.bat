@echo off
echo Compilando Tests...
cd tests\App.Core.Tests
dcc32.exe -CC -U"..\..\src\App.Core" -E"." "AppCoreTests.dpr"
if errorlevel 1 goto :error

echo.
echo Ejecutando Tests...
AppCoreTests.exe
cd ..\..

echo.
echo Compilando Windows App...
cd src\App.Win
dcc32.exe -U"..\App.Core" -E"." "WindowsApp.dpr"
if errorlevel 1 goto :error
cd ..\..

echo.
echo Todo compilado correctamente.
goto :end

:error
echo ERROR: Fallo la compilacion.
exit /b 1

:end
