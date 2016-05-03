#!/bin/sh

## run via '. setenv.sh'
##
##

if [ -z "${JAVA_HOME}" ]
then
  echo "JAVA_HOME not set"
  exit 0
fi

if [ ! -x "${JAVA_HOME}/bin/java" ]
then
  echo Cannot find java executable, check JAVA_HOME
  exit 0
fi

EE_HOME=../../..

CLASSPATH=.
CLASSPATH=$CLASSPATH:../target/classes

CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper-5.3.0.jar
CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper-jmx-5.3.0.jar

CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper/cglib-nodep-3.1.jar
CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper/commons-logging-1.1.3.jar
CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper/log4j-1.2.17.jar
CLASSPATH=$CLASSPATH:$EE_HOME/lib/esper/antlr-runtime-4.1.jar

export CLASSPATH="$CLASSPATH"
