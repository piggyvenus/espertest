@echo off

REM Script to run example generator
REM

call ..\..\setenv.bat

set MEMORY_OPTIONS=-Xms256m -Xmx256m -XX:+UseParNewGC

REM To enable the Sun JVM platform mbean connector, add the following options:
REM -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false
REM

"%JAVA_HOME%"\bin\java %MEMORY_OPTIONS% -Dlog4j.configuration=log4j.xml com.espertech.esper.jmx.example.TrafficExampleServerMain %1 %2