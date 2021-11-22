@ECHO off

SET filename="FS22_Survival.zip"

IF EXIST %filename% (
    DEL  %filename% > NUL
)

"7z" a -tzip %filename% ^
   -i!*.lua ^
   -i!*.dds ^
   -i!*.xml ^
   -xr!.idea ^
   -xr!.git ^
   -aoa -r ^

IF %ERRORLEVEL% NEQ 0 ( exit 1 )

exit
