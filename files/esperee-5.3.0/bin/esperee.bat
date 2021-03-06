@echo off
if "%OS%" == "Windows_NT" setlocal
rem ---------------------------------------------------------------------------
rem Start/Stop Script for the ESPEREE Server
rem
rem Environment Variable Prequisites
rem
rem   ESPEREE_HOME   May point at your EsperEE "build" directory.
rem
rem   ESPEREE_BASE   (Optional) Base directory for resolving dynamic portions
rem                   of a EsperEE installation.  If not present, resolves to
rem                   the same directory that ESPEREE_HOME points to.
rem
rem   ESPEREE_OPTS   (Optional) Java runtime options used when the "start",
rem                   or "run" command is executed.
rem
rem   ESPEREE_TMPDIR (Optional) Directory path location of temporary directory
rem                   the JVM should use (java.io.tmpdir).  Defaults to
rem                   %ESPEREE_BASE%\temp.
rem
rem   JAVA_HOME       Must point at your Java Development Kit installation.
rem                   Required to run the with the "debug" argument.
rem
rem   JRE_HOME        Must point at your Java Runtime installation.
rem                   Defaults to JAVA_HOME if empty.
rem
rem   JAVA_OPTS       (Optional) Java runtime options used when the "start",
rem                   "stop", or "run" command is executed.
rem
rem   JSSE_HOME       (Optional) May point at your Java Secure Sockets Extension
rem                   (JSSE) installation, whose JAR files will be added to the
rem                   system class path used to start.
rem
rem   JPDA_TRANSPORT  (Optional) JPDA transport used when the "jpda start"
rem                   command is executed. The default is "dt_shmem".
rem
rem   JPDA_ADDRESS    (Optional) Java runtime options used when the "jpda start"
rem                   command is executed. The default is "jdbconn".
rem
rem   JPDA_SUSPEND    (Optional) Java runtime options used when the "jpda start"
rem                   command is executed. Specifies whether JVM should suspend
rem                   execution immediately after startup. Default is "n".
rem
rem   JPDA_OPTS       (Optional) Java runtime options used when the "jpda start"
rem                   command is executed. If used, JPDA_TRANSPORT, JPDA_ADDRESS,
rem                   and JPDA_SUSPEND are ignored. Thus, all required jpda
rem                   options MUST be specified. The default is:
rem
rem                   -agentlib:jdwp=transport=%JPDA_TRANSPORT%,
rem                       address=%JPDA_ADDRESS%,server=y,suspend=%JPDA_SUSPEND%
rem
rem   LOGGING_CONFIG  (Optional) Override LOG4J logging config file.
rem
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

rem Get standard environment variables
if "%ESPEREE_BASE%" == "" goto gotSetenvHome
if exist "%ESPEREE_BASE%\bin\setenv.bat" call "%ESPEREE_BASE%\bin\setenv.bat"
goto gotSetenvBase
:gotSetenvHome
if exist "%ESPEREE_HOME%\bin\setenv.bat" call "%ESPEREE_HOME%\bin\setenv.bat"
:gotSetenvBase

rem Get standard Java environment variables
if exist "%ESPEREE_HOME%\bin\setclasspath.bat" goto okSetclasspath
echo Cannot find %ESPEREE_HOME%\bin\setclasspath.bat
echo This file is needed to run this program
goto end
:okSetclasspath
set BASEDIR=%ESPEREE_HOME%
call "%ESPEREE_HOME%\bin\setclasspath.bat" %1
if errorlevel 1 goto end

rem Add on extra jar files to CLASSPATH
if "%JSSE_HOME%" == "" goto noJsse
set CLASSPATH=%CLASSPATH%;%JSSE_HOME%\lib\jcert.jar;%JSSE_HOME%\lib\jnet.jar;%JSSE_HOME%\lib\jsse.jar
:noJsse
set CLASSPATH=%CLASSPATH%;%ESPEREE_HOME%\bin\bootstrap.jar

if not "%ESPEREE_BASE%" == "" goto gotBase
set ESPEREE_BASE=%ESPEREE_HOME%
:gotBase

if not "%ESPEREE_TMPDIR%" == "" goto gotTmpdir
set ESPEREE_TMPDIR=%ESPEREE_BASE%\temp
:gotTmpdir

if not "%LOGGING_CONFIG%" == "" goto noLog4jConfig
set LOGGING_CONFIG=-Dlog4j.configuration=log4j.xml
if not exist "%ESPEREE_BASE%\conf\logging.properties" goto noLog4jConfig
set LOGGING_CONFIG=-Djava.util.logging.config.file=%ESPEREE_BASE%\conf\logging.properties
:noLog4jConfig
set JAVA_OPTS=%JAVA_OPTS% %LOGGING_CONFIG%

if not "%ESPEREE_OPTS%" == "" goto gotEEEOptions
set ESPEREE_OPTS=-Xms128m -Xmx1024m -javaagent:%ESPEREE_BASE%\lib\esper-eeutilagent-5.3.0.jar
:gotEEEOptions

rem ----- Execute The Requested Command ---------------------------------------

echo Using ESPEREE_BASE:   %ESPEREE_BASE%
echo Using ESPEREE_HOME:   %ESPEREE_HOME%
echo Using ESPEREE_TMPDIR: %ESPEREE_TMPDIR%
echo Using ESPEREE_OPTS:   %ESPEREE_OPTS%
if ""%1"" == ""debug"" goto use_jdk
echo Using JRE_HOME:        %JRE_HOME%
goto java_dir_displayed
:use_jdk
echo Using JAVA_HOME:       %JAVA_HOME%
:java_dir_displayed

set _EXECJAVA=%_RUNJAVA%
set MAINCLASS=com.espertech.esper.server.Bootstrap
set ACTION=start
set SECURITY_POLICY_FILE=
set DEBUG_OPTS=
set JPDA=

if not ""%1"" == ""jpda"" goto noJpda
set JPDA=jpda
if not "%JPDA_TRANSPORT%" == "" goto gotJpdaTransport
set JPDA_TRANSPORT=dt_socket
:gotJpdaTransport
if not "%JPDA_ADDRESS%" == "" goto gotJpdaAddress
set JPDA_ADDRESS=8000
:gotJpdaAddress
if not "%JPDA_SUSPEND%" == "" goto gotJpdaSuspend
set JPDA_SUSPEND=n
:gotJpdaSuspend
if not "%JPDA_OPTS%" == "" goto gotJpdaOpts
set JPDA_OPTS=-agentlib:jdwp=transport=%JPDA_TRANSPORT%,address=%JPDA_ADDRESS%,server=y,suspend=%JPDA_SUSPEND%
:gotJpdaOpts
shift
:noJpda

if ""%1"" == ""debug"" goto doDebug
if ""%1"" == ""run"" goto doRun
if ""%1"" == ""instrumented"" goto doRun
if ""%1"" == ""start"" goto doStart
if ""%1"" == ""stop"" goto doStop
if ""%1"" == ""version"" goto doVersion

echo Usage:  esperee ( commands ... )
echo commands:
echo   debug             Start EsperEE in a debugger
echo   debug -security   Debug EsperEE with a security manager
echo   jpda start        Start EsperEE under JPDA debugger
echo   run               Start EsperEE in the current window
echo   run -security     Start in the current window with security manager
echo   start             Start EsperEE in a separate window
echo   start -security   Start in a separate window with security manager
echo   stop              Stop EsperEE
echo   instrumented      Start EsperEE instrumented for use with EPL debugger
echo   version           What version of EsperEE are you running?
goto end

:doDebug
shift
set _EXECJAVA=%_RUNJDB%
set DEBUG_OPTS=-sourcepath "%ESPEREE_HOME%\..\..\java"
if not ""%1"" == ""-security"" goto execCmd
shift
echo Using Security Manager
set SECURITY_POLICY_FILE=%ESPEREE_BASE%\conf\esperee.policy
goto execCmd

:doRun
shift
if not ""%1"" == ""-security"" goto execCmd
shift
echo Using Security Manager
set SECURITY_POLICY_FILE=%ESPEREE_BASE%\conf\esperee.policy
goto execCmd

:doStart
shift
if not "%OS%" == "Windows_NT" goto noTitle
set _EXECJAVA=start "EsperEE" %_RUNJAVA%
goto gotTitle
:noTitle
set _EXECJAVA=start %_RUNJAVA%
:gotTitle
if not ""%1"" == ""-security"" goto execCmd
shift
echo Using Security Manager
set SECURITY_POLICY_FILE=%ESPEREE_BASE%\conf\esperee.policy
goto execCmd

:doStop
shift
set ACTION=stop
set ESPEREE_OPTS=
goto execCmd

:doVersion
%_EXECJAVA% com.espertech.esper.server.ServerInfo
goto end


:execCmd
rem Get remaining unshifted command line arguments and save them in the
set CMD_LINE_ARGS=
:setArgs
if ""%1""=="""" goto doneSetArgs
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto setArgs
:doneSetArgs

rem Execute Java with the applicable properties
if not "%JPDA%" == "" goto doJpda
if not "%SECURITY_POLICY_FILE%" == "" goto doSecurity
%_EXECJAVA% %JAVA_OPTS% %ESPEREE_OPTS% %DEBUG_OPTS% -Djava.endorsed.dirs="%JAVA_ENDORSED_DIRS%" -classpath "%CLASSPATH%" -Desperee.base="%ESPEREE_BASE%" -Desperee.home="%ESPEREE_HOME%" -Djava.io.tmpdir="%ESPEREE_TMPDIR%" %MAINCLASS% %CMD_LINE_ARGS% %ACTION%
goto end
:doSecurity
%_EXECJAVA% %JAVA_OPTS% %ESPEREE_OPTS% %DEBUG_OPTS% -Djava.endorsed.dirs="%JAVA_ENDORSED_DIRS%" -classpath "%CLASSPATH%" -Djava.security.manager -Djava.security.policy=="%SECURITY_POLICY_FILE%" -Desperee.base="%ESPEREE_BASE%" -Desperee.home="%ESPEREE_HOME%" -Djava.io.tmpdir="%ESPEREE_TMPDIR%" %MAINCLASS% %CMD_LINE_ARGS% %ACTION%
goto end
:doJpda
if not "%SECURITY_POLICY_FILE%" == "" goto doSecurityJpda
%_EXECJAVA% %JAVA_OPTS% %ESPEREE_OPTS% %JPDA_OPTS% %DEBUG_OPTS% -Djava.endorsed.dirs="%JAVA_ENDORSED_DIRS%" -classpath "%CLASSPATH%" -Desperee.base="%ESPEREE_BASE%" -Desperee.home="%ESPEREE_HOME%" -Djava.io.tmpdir="%ESPEREE_TMPDIR%" %MAINCLASS% %CMD_LINE_ARGS% %ACTION%
goto end
:doSecurityJpda
%_EXECJAVA% %JAVA_OPTS% %ESPEREE_OPTS% %JPDA_OPTS% %DEBUG_OPTS% -Djava.endorsed.dirs="%JAVA_ENDORSED_DIRS%" -classpath "%CLASSPATH%" -Djava.security.manager -Djava.security.policy=="%SECURITY_POLICY_FILE%" -Desperee.base="%ESPEREE_BASE%" -Desperee.home="%ESPEREE_HOME%" -Djava.io.tmpdir="%ESPEREE_TMPDIR%" %MAINCLASS% %CMD_LINE_ARGS% %ACTION%
goto end

:end
