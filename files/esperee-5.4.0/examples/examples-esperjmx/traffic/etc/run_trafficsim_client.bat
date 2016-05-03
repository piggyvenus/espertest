@echo off

REM Script to run example client
REM

call ..\..\setenv.bat

set MEMORY_OPTIONS=-Xms256m -Xmx256m -XX:+UseParNewGC

"%JAVA_HOME%"\bin\java %MEMORY_OPTIONS% -Dlog4j.configuration=log4j.xml com.espertech.esper.jmx.example.TrafficExampleClientMain %1 %2