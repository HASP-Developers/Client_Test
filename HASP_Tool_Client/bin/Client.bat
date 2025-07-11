@REM  Copyright (C) 2024 HASP-CNS Tool Development Team
@REM  This file is part of HASP-CNS Tool
@REM    _   _    _    ____  ____
@REM   | | | |  / \  / ___||  _ \
@REM   | |_| | / _ \ \___ \| |_) |
@REM   |  _  |/ ___ \ ___) |  __/
@REM   |_| |_/_/   \_\____/|_|
@REM                         =============
@REM                      ===================
@REM                   =========================
@REM                 =============================
@REM               ==========             =========
@REM              ========                  =========
@REM             ========   @@          @@@@@@ =======
@REM            ======@@@@@@@@@@       @@@@@@@@@======@@@@
@REM      @@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@=======@@@@@@@@@@@
@REM  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=======@@
@REM            =======     @@@@@@@@@@@@@@@     =======
@REM            =======      @@@@@@@@@@@@       =======
@REM            =======      @@@@@@@@@@@@@@@    =======
@REM            ========    @@@@@@@            =======
@REM             ========   @@@@@             ========
@REM              ========  @@              =========
@REM               ==========             =========
@REM                 ============    =============
@REM                   =========================
@REM                     =====================
@REM                         =============
@REM                      ____ _   _ ____      _____           _
@REM                     / ___| \ | / ___|    |_   _|__   ___ | |
@REM                    | |   |  \| \___ \ _____| |/ _ \ / _ \| |
@REM                    | |___| |\  |___) |_____| | (_) | (_) | |
@REM                     \____|_| \_|____/      |_|\___/ \___/|_|
@REM  can not be copied and/or distributed without permission

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
for %%i in ("%~dp0..") do set "BASEDIR=%%~fi"

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\lib

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\*

set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% -Xmx8G -Xms512m -Dstdout.encoding=UTF-8 -classpath %CLASSPATH% -Dapp.name="Client" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" com.hasp.start.Starter %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
