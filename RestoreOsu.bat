@echo off
::Check Administrator Privileges
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:start    
set main=%~dp0%
set extr=%~dp0%\7z.exe
::Compress OsuLazer Game
echo Backup of OsuLazer Game
IF EXIST %main%\Osulazer.zip (
    GOTO RESTG
) ELSE (
    echo Backup game File not found exit
    timeout /t 2 /nobreak > NUL
    GOTO EOF
)
:RESTG
    echo Restore Osulazer Game
    start /wait /min %extr% x %main%\OsuLazer.zip -o%APPDATA% -aoa> NUL
    GOTO NEXT
:NEXT
    IF EXIST %main%\OsuData.zip (
    GOTO RESTD
    ) ELSE (
        echo Backup game data File not found exit
    timeout /t 2 /nobreak > NUL
    GOTO EOF
    )
:RESTD
    echo Restore Osulazer DATA
    start /wait /min %extr% x %main%\OsuData.zip -o%APPDATA% -aoa> NUL
    echo Finish
    echo Make a desktop SHORTCUT
    set TARGET='%APPDATA%\osulazer\osu!.exe'
    set SHORTCUT='%USERPROFILE%\Desktop\osulazer!.lnk'
    set PWS=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
    %PWS% -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut(%SHORTCUT%); $S.TargetPath = %TARGET%; $S.Save()"
    echo Finish!!!
    pause
    GOTO EOF
exit
