@echo off

call ..\..\setenv.bat

if not exist "..\target" (
  mkdir ..\target
)
if not exist "..\target\classes" (
  mkdir ..\target\classes
)

set SOURCEPATH=..\src\main\java

"%JAVA_HOME%"\bin\javac -d ..\target\classes -source 1.7 -sourcepath %SOURCEPATH% %SOURCEPATH%\com\espertech\esper\ceppushsvc\examples\traffic\server\SampleTrafficMonitorServer.java %SOURCEPATH%\com\espertech\esper\ceppushsvc\examples\traffic\client\SampleTrafficMonitorClient.java
