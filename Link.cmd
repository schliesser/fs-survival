@echo off

set modName=FS22_Survival
rem the profile path
set gameProfile=%UserProfile%/Documents/My Games/FarmingSimulator2022/
set branch = %cd%

rem DO NOT EDIT BELOW

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

echo %gameProfile%mods/%modName%
IF exist "%gameProfile%mods/%modName%" (
    rmdir "%gameProfile%mods/%modName%"
)
mklink /D /J "%gameProfile%mods/%modName%" "%branch%."

exit
