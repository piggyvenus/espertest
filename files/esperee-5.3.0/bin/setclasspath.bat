@echo off
rem ---------------------------------------------------------------------------
rem Set EsperEE CLASSPATH.
rem
rem ---------------------------------------------------------------------------

rem Make sure prerequisite environment variables are set
if not "%JAVA_HOME%" == "" goto gotJdkHome
if not "%JRE_HOME%" == "" goto gotJreHome
echo Neither the JAVA_HOME nor the JRE_HOME environment variable is defined
echo At least one of these environment variable is needed to run this program
goto exit

:gotJreHome
if not exist "%JRE_HOME%\bin\java.exe" goto noJavaHome
if not exist "%JRE_HOME%\bin\javaw.exe" goto noJavaHome
if not ""%1"" == ""debug"" goto okJavaHome
echo JAVA_HOME should point to a JDK in order to run in debug mode.
goto exit

:gotJdkHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
if not exist "%JAVA_HOME%\bin\javaw.exe" goto noJavaHome
if not "%JRE_HOME%" == "" goto okJavaHome
set JRE_HOME=%JAVA_HOME%
goto okJavaHome

:noJavaHome
echo The JAVA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
echo NB: JAVA_HOME should point to a JDK not a JRE
goto exit
:okJavaHome

if not "%BASEDIR%" == "" goto gotBasedir
echo The BASEDIR environment variable is not defined.
echo This environment variable is needed to run this program
goto exit
:gotBasedir
if exist "%BASEDIR%\bin\setclasspath.bat" goto okBasedir
echo The BASEDIR environment variable is not defined correctly
echo This environment variable is needed to run this program
goto exit
:okBasedir

rem Don't override the endorsed dir if the user has set it previously
if not "%JAVA_ENDORSED_DIRS%" == "" goto gotEndorseddir
rem Set the default -Djava.endorsed.dirs argument
set JAVA_ENDORSED_DIRS=%BASEDIR%\endorsed
:gotEndorseddir

rem Set standard CLASSPATH
rem Note that there are no quotes as we do not want to introduce random
rem quotes into the CLASSPATH
if not exist "%JAVA_HOME%\lib\tools.jar" goto noJavac
set CLASSPATH=%JAVA_HOME%\lib\tools.jar
:noJavac

rem Set standard command for invoking Java.
rem Note that NT requires a window name argument when using start.
rem Also note the quoting as JAVA_HOME may contain spaces.
set _RUNJAVA="%JRE_HOME%\bin\java"
set _RUNJAVAW="%JRE_HOME%\bin\javaw"
set _RUNJDB="%JAVA_HOME%\bin\jdb"
set _RUNJAVAC="%JAVA_HOME%\bin\javac"

rem Production settings
set LIB=%BASEDIR%\lib
set LIB_SECURITY=%BASEDIR%\lib-security
set ESPER_DEP_LIB=%LIB%\esper
set ESPERSERVER_DEP_LIB=%LIB%\esper-server
set ESPERJDBC_DEP_LIB=%LIB%\esper-jdbc
set ESPERHA_DEP_LIB=%LIB%\esperha

set CLASSPATH=.;..\conf;%BASEDIR%\conf

rem Esper Core CEP Engine
rem
if not ""%1"" == ""instrumented"" goto use_uninstrumented
echo Using instrumented engine
set CLASSPATH=%CLASSPATH%;%LIB%\esper-instrumented-5.3.0.jar
goto core_cp_done
:use_uninstrumented
set CLASSPATH=%CLASSPATH%;%LIB%\esper-5.3.0.jar
:core_cp_done

rem Esper EE jar files
rem
set CLASSPATH=%CLASSPATH%;%LIB%\esper-eeutil-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-eeutilagent-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-cepmgmtsvc-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-ceppushsvc-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-hqsvc-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jmx-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-server-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jdbc-driver-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-jdbc-server-5.3.0.jar
set CLASSPATH=%CLASSPATH%;%LIB%\esper-dataflow-sockete2e-5.3.0.jar

rem Esper dependencies
rem
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\cglib-nodep-3.1.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\commons-logging-1.1.3.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\log4j-1.2.17.jar
set CLASSPATH=%CLASSPATH%;%ESPER_DEP_LIB%\antlr-runtime-4.1.jar

rem Esper Server dependencies
rem
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javassist-3.19.0-GA.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jgroups-3.6.2.Final.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\servlet-api-3.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javax.ws.rs.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.httpclient.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.jaxrs.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.servlet.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.ext.slf4j.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\org.restlet.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javax-websocket-client-impl-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javax-websocket-server-impl-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\javax.websocket-api-1.0.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-api-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-client-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-common-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-server-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\websocket-servlet-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-alpn-client-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-alpn-server-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-annotations-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-cdi-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-client-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-continuation-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-deploy-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-http-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-io-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jaas-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jaspi-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jmx-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-jndi-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-plus-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-proxy-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-quickstart-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-rewrite-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-schemas-3.1.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-security-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-server-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-servlet-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-servlets-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-util-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-webapp-9.2.9.v20150224.jar
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\jetty-xml-9.2.9.v20150224.jar
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
set CLASSPATH=%CLASSPATH%;%ESPERSERVER_DEP_LIB%\kryo-2.22-all.jar

rem Esper Groovy dependencies
rem
rem set CLASSPATH=%CLASSPATH%;%LIB%\esper-dataflow-groovy-5.3.0.jar

rem Esper JDBC dependencies
rem
rem set CLASSPATH=%CLASSPATH%;%ESPERJDBC_DEP_LIB%\mina-core-2.0.7.jar

rem Examples - comment in when running the example as a plug-in, not required when deploying the example as a war file
rem
rem set CLASSPATH=%CLASSPATH%;%LIB%\esper-example-geo-5.3.0.jar;..\..\example_geo\target\esper-example-geo-5.3.0.jar
rem set CLASSPATH=%CLASSPATH%;%LIB%\esper-example-onlineshop-5.3.0.jar;..\..\example_onlineshop\target\esper-example-onlineshop-5.3.0.jar
rem set CLASSPATH=%CLASSPATH%;%LIB%\esper-example-optiontrade-5.3.0.jar;..\..\example_optiontrade\target\esper-example-optiontrade-5.3.0.jar

rem Esper HA dependencies
rem
rem set CLASSPATH=%CLASSPATH%;%ESPERHA_DEP_LIB%\esperha-core-5.3.0.jar
rem set CLASSPATH=%CLASSPATH%;%ESPERHA_DEP_LIB%\esperha-ehafile-5.3.0.jar
rem set CLASSPATH=%CLASSPATH%;%ESPERHA_DEP_LIB%\esperha-xsdboe-5.3.0.jar

rem Spring/ACEGI Security
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-aop-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-aspects-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-beans-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-build-src-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-context-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-context-support-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-core-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-expression-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-instrument-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-jdbc-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-jms-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-oxm-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-acl-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-aspects-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-cas-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-config-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-core-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-crypto-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-ldap-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-openid-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-remoting-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-taglibs-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-security-web-3.1.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-tx-3.2.4.RELEASE.jar
rem set CLASSPATH=%CLASSPATH%;%LIB_SECURITY%\spring-web-3.2.4.RELEASE.jar

rem echo Using CLASSPATH=%CLASSPATH%

goto end

:exit
exit /b 1

:end
