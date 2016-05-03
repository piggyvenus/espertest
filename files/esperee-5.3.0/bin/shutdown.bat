@echo off
if "%OS%" == "Windows_NT" setlocal
rem ---------------------------------------------------------------------------
rem Stop script for the ESPEREE Server
rem ---------------------------------------------------------------------------

rem Guess ESPEREE_HOME if not defined
set CURRENT_DIR=%cd%
if not "%ESPEREE_HOME%" == "" goto gotHome
set ESPEREE_HOME=%CURRENT_DIR%
if exist "%ESPEREE_HOME%\bin\esperee.bat" goto okHome
cd ..
set ESPEREE_HOME=%cd%
cd %CURRENT_DIR%
:gotHome
if exist "%ESPEREE_HOME%\bin\esperee.bat" goto okHome
echo The ESPEREE_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end
:okHome

set EXECUTABLE=%ESPEREE_HOME%\bin\esperee.bat

rem Check that target executable exists
if exist "%EXECUTABLE%" goto okExec
echo Cannot find %EXECUTABLE%
echo This file is needed to run this program
goto end
:okExec

rem Get remaining unshifted command line arguments and save them in the
set CMD_LINE_ARGS=
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs

call "%EXECUTABLE%" stop %CMD_LINE_ARGS%

:end
