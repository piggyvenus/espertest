#!/bin/sh

# -----------------------------------------------------------------------------
#  EsperEE CLASSPATH.
# -----------------------------------------------------------------------------

# First clear out the user classpath
CLASSPATH=

# Make sure prerequisite environment variables are set
if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]
then
  # Bugzilla 37284 (reviewed).
  if $darwin
  then
    if [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]
    then
      export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
    fi
  else
    JAVA_PATH=`which java 2>/dev/null`
    if [ "x$JAVA_PATH" != "x" ]
    then
      JAVA_PATH=`dirname $JAVA_PATH 2>/dev/null`
      JRE_HOME=`dirname $JAVA_PATH 2>/dev/null`
    fi
    if [ "x$JRE_HOME" = "x" ]
    then
      if [ -x /usr/bin/java ]
      then
        JRE_HOME=/usr
      fi
    fi
  fi
  if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]
  then
    echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
    echo "At least one of these environment variable is needed to run this program"
    exit 1
  fi
fi
if [ -z "$JAVA_HOME" -a "$1" = "debug" ]
then
  echo "JAVA_HOME should point to a JDK in order to run in debug mode."
  exit 1
fi
if [ -z "$JRE_HOME" ]
then
  JRE_HOME="$JAVA_HOME"
fi

# If we're running under jdb, we need a full jdk.
if [ "$1" = "debug" -o "$1" = "javac" ] 
then
  if [ "$os400" = "true" ]
  then
    if [ ! -x "$JAVA_HOME"/bin/java ]
    then
      echo "The JAVA_HOME environment variable is not defined correctly"
      echo "This environment variable is needed to run this program"
      echo "NB: JAVA_HOME should point to a JDK not a JRE"
      exit 1
    fi
  else
    if [ ! -x "$JAVA_HOME"/bin/java ]
    then
      echo "The JAVA_HOME environment variable is not defined correctly"
      echo "This environment variable is needed to run this program"
      echo "NB: JAVA_HOME should point to a JDK not a JRE"
      exit 1
    fi
  fi
fi
if [ -z "$BASEDIR" ]
then
  echo "The BASEDIR environment variable is not defined"
  echo "This environment variable is needed to run this program"
  exit 1
fi
if [ ! -x "$BASEDIR"/bin/setclasspath.sh ]
then
  if $os400
  then
    # -x will Only work on the os400 if the files are:
    # 1. owned by the user
    # 2. owned by the PRIMARY group of the user
    # this will not work if the user belongs in secondary groups
    eval
  else
    echo "The BASEDIR environment variable is not defined correctly"
    echo "This environment variable is needed to run this program"
    exit 1
  fi
fi

# Don't override the endorsed dir if the user has it previously
if [ -z "$JAVA_ENDORSED_DIRS" ]
then
  # the default -Djava.endorsed.dirs argument
  JAVA_ENDORSED_DIRS="$BASEDIR"/endorsed
fi

# standard CLASSPATH
if [ "$1" = "javac" ] 
then
  if [ ! -f "$JAVA_HOME"/lib/tools.jar ]
  then
    echo "Can't find tools.jar in JAVA_HOME"
    echo "Need a JDK to run javac"
    exit 1
  fi
fi
if [ "$1" = "debug" -o "$1" = "javac" ] 
then
  if [ -f "$JAVA_HOME"/lib/tools.jar ]
  then
    CLASSPATH="$JAVA_HOME"/lib/tools.jar
  fi
fi

# standard commands for invoking Java.
_RUNJAVA="$JRE_HOME"/bin/java
if [ "$os400" != "true" ]
then
  _RUNJDB="$JAVA_HOME"/bin/jdb
fi
_RUNJAVAC="$JAVA_HOME"/bin/javac

LIB=$BASEDIR/lib
LIB_SECURITY=$BASEDIR/lib-security
ESPER_DEP_LIB=$LIB/esper
ESPERSERVER_DEP_LIB=$LIB/esper-server
ESPERJDBC_DEP_LIB=$LIB/esper-jdbc
ESPERHA_DEP_LIB=$LIB/esperha

CLASSPATH=$BASEDIR/conf

#  Esper Core CEP Engine jar file
#
if [ "$1" = "instrumented" -o "$2" = "instrumented" ] 
then
  CLASSPATH=$CLASSPATH:$LIB/esper-instrumented-5.4.0.jar
else
  CLASSPATH=$CLASSPATH:$LIB/esper-5.4.0.jar
fi

#  Esper EE jar files
#
CLASSPATH=$CLASSPATH:$LIB/esper-eeutil-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-eeutilagent-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-cepmgmtsvc-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-ceppushsvc-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-hqsvc-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-jmx-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-server-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-jdbc-driver-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-jdbc-server-5.4.0.jar
CLASSPATH=$CLASSPATH:$LIB/esper-dataflow-sockete2e-5.4.0.jar

#  Esper dependencies
#
CLASSPATH=$CLASSPATH:$ESPER_DEP_LIB/cglib-nodep-3.1.jar
CLASSPATH=$CLASSPATH:$ESPER_DEP_LIB/commons-logging-1.1.3.jar
CLASSPATH=$CLASSPATH:$ESPER_DEP_LIB/log4j-1.2.17.jar
CLASSPATH=$CLASSPATH:$ESPER_DEP_LIB/antlr-runtime-4.1.jar

#  Esper Server dependencies
#
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/javassist-3.19.0-GA.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jgroups-3.6.2.Final.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/servlet-api-3.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/javax.ws.rs.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/org.restlet.ext.httpclient.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/org.restlet.ext.jaxrs.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/org.restlet.ext.servlet.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/org.restlet.ext.slf4j.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/org.restlet.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/javax-websocket-client-impl-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/javax-websocket-server-impl-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/javax.websocket-api-1.0.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/websocket-api-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/websocket-client-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/websocket-common-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/websocket-server-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/websocket-servlet-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-alpn-client-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-alpn-server-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-annotations-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-cdi-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-client-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-continuation-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-deploy-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-http-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-io-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-jaas-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-jaspi-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-jmx-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-jndi-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-plus-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-proxy-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-quickstart-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-rewrite-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-schemas-3.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-security-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-server-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-servlet-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-servlets-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-util-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-webapp-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/jetty-xml-9.2.9.v20150224.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/activemq-all-5.11.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/geronimo-j2ee-management_1.1_spec-1.0.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/geronimo-jms_1.1_spec-1.1.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/gson-2.3.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/xstream-1.4.4.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/slf4j-api-1.7.2.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/slf4j-log4j12-1.7.2.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/commons-codec-1.6.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/commons-lang-2.6.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/httpclient-4.4.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/httpcore-4.4.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/groovy-all-2.4.1.jar
CLASSPATH=$CLASSPATH:$ESPERSERVER_DEP_LIB/kryo-2.22-all.jar

# Esper Groovy dependencies
#
# CLASSPATH=$CLASSPATH:$LIB/esper-dataflow-groovy-5.4.0.jar

#  Esper JDBC dependencies
#
# CLASSPATH=$CLASSPATH:$ESPERJDBC_DEP_LIB/mina-core-2.0.7.jar

#  Examples - comment in when running the example as a plug-in, not required when deploying the example as a war file
#
# CLASSPATH=$CLASSPATH:$LIB/esper-example-geo-5.4.0.jar
# CLASSPATH=$CLASSPATH:$LIB/esper-example-onlineshop-5.4.0.jar
# CLASSPATH=$CLASSPATH:$LIB/esper-example-optiontrade-5.4.0.jar

#  Esper HA dependencies
#
# CLASSPATH=$CLASSPATH:$ESPERHA_DEP_LIB/esperha-core-5.4.0.jar
# CLASSPATH=$CLASSPATH:$ESPERHA_DEP_LIB/esperha-ehafile-5.4.0.jar
# CLASSPATH=$CLASSPATH:$ESPERHA_DEP_LIB/esperha-xsdboe-5.4.0.jar

#  Spring/ACEGI Security
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-aop-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-aspects-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-beans-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-build-src-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-context-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-context-support-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-core-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-expression-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-instrument-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-jdbc-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-jms-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-oxm-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-acl-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-aspects-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-cas-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-config-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-core-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-crypto-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-ldap-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-openid-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-remoting-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-taglibs-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-security-web-3.1.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-tx-3.2.4.RELEASE.jar
# CLASSPATH=$CLASSPATH:$LIB_SECURITY/spring-web-3.2.4.RELEASE.jar

export CLASSPATH="$CLASSPATH"
