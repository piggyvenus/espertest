@echo off

if "%JAVA_HOME%" == "" (
  echo.
  echo JAVA_HOME not set
  goto EOF
)

if not exist "%JAVA_HOME%\bin\java.exe" (
  echo.
  echo Cannot find java executable, check JAVA_HOME
  goto EOF
)

set EE_HOME=..\..\..

set CLASSPATH=.
set CLASSPATH=%CLASSPATH%;..\target\classes

set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-jdbc-server-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-jdbc-driver-5.4.0.jar

set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper\cglib-nodep-3.1.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper\commons-logging-1.1.3.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper\log4j-1.2.17.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper\antlr-runtime-4.1.jar

@rem ** EsperJDBC
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-jdbc\mina-core-2.0.0-M1.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-jdbc\slf4j-api-1.5.0.jar
set CLASSPATH=%CLASSPATH%;%EE_HOME%\lib\esper-jdbc\slf4j-log4j12-1.5.0.jar
