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

set EE_HOME=..\..\..\..
set LIB=%EE_HOME%\lib
set ESPER_DEP_LIB=%EE_HOME%\lib\esper
set ESPERSERVER_DEP_LIB=%EE_HOME%\lib\esper-server

set CLASSPATH=.
set CLASSPATH=%CLASSPATH%;..\target\classes;.

rem Esper EE jar files (depends on plug-ins activated)
set CLASSPATH=%CLASSPATH%;%LIB%\esper-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-eeutil-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-cepmgmtsvc-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-ceppushsvc-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-hqsvc-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jmx-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-server-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jdbc-driver-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jdbc-server-5.4.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-dataflow-sockete2e-5.4.0.jar

rem Esper dependencies
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\cglib-nodep-3.1.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\commons-logging-1.1.3.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\log4j-1.2.17.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\antlr-runtime-4.1.jar

rem Esper Server dependencies
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javassist.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jgroups-3.3.3.Final.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\servlet-api-3.0.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javax.ws.rs.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.httpclient.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.jaxrs.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.servlet.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.slf4j.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-annotations-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-client-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-continuation-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-deploy-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-http-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-io-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jaas-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jmx-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-plus-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-proxy-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-rewrite-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-security-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-server-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-servlet-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-servlets-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-util-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-webapp-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-xml-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-api-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-common-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-server-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-servlet-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\activemq-all-5.11.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\geronimo-j2ee-management_1.1_spec-1.0.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\geronimo-jms_1.1_spec-1.1.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\gson-2.3.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\xstream-1.4.4.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\slf4j-api-1.7.2.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\slf4j-log4j12-1.7.2.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\commons-codec-1.6.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\commons-lang-2.6.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\httpclient-4.4.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\httpcore-4.4.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\groovy-all-2.4.1.jar
