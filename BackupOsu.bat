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
set extr=%~dp0%\7za.exe
::Compress OsuLazer Game
IF EXIST %main%\Osulazer.zip (
    GOTO REMP
) ELSE (
    GOTO BACKG
)
:BACKG
    echo Backup Osulazer Game
    start /wait /min %extr% a OsuLazer.zip %APPDATA%\osuLazer> NUL
    GOTO NEXT
:REMP
    echo Old game backup file found deleting.......
    echo Delete old Backup
    del %main%\Osulazer.zip
    timeout /t 2 /nobreak
    echo Backup Osulazer Game
    start /wait /min %extr% a OsuLazer.zip %APPDATA%\osuLazer> NUL
    GOTO NEXT
:NEXT
    IF EXIST %main%\OsuData.zip (
    GOTO REMPD
    ) ELSE (
    GOTO BACKD
    )
:BACKD
    echo Backup of Osu Data
    start /wait /min %extr% a OsuData.zip %APPDATA%\osu> NUL
    echo Finish
    pause
    GOTO EOF
:REMPD
    echo Old data backup file found deleting.......
    echo Delete old Data Backup
    del %main%\OsuData.zip
    timeout /t 2 /nobreak > NUL
    echo Backup Osulazer Data
    start /wait /min %extr% a OsuData.zip %APPDATA%\osu> NUL
    echo Finish
    pause
    GOTO EOF
exit
