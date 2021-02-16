@ECHO off

SET filename="FS19_Survival.zip"

IF EXIST %filename% (
    DEL  %filename% > NUL
)

"7z.exe" a -tzip %filename% ^
   -i!*.lua ^
   -i!*.dds ^
   -i!*.png ^
   -i!*.xml ^
   -xr!.idea ^
   -xr!.git ^
   -aoa -r ^

IF %ERRORLEVEL% NEQ 0 ( exit 1 )

PAUSE
