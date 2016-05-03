@echo off

REM Script to run DDS Traffic Client example
REM

call ..\..\setenv.bat

set MEMORY_OPTIONS=-Xms256m -Xmx256m -XX:+UseParNewGC

"%JAVA_HOME%"\bin\java %MEMORY_OPTIONS% -Dlog4j.configuration=log4j.xml com.espertech.esper.ceppushsvc.examples.traffic.client.SampleTrafficMonitorClient
