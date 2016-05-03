#!/bin/sh

# Script to run SLA report server example
#

. ../../setenv.sh

MEMORY_OPTIONS="-Xms256m -Xmx256m -XX:+UseParNewGC"

$JAVA_HOME/bin/java $MEMORY_OPTIONS -Dlog4j.configuration=log4j.xml -cp ${CLASSPATH} com.espertech.esper.jdbc.examples.slareport.SLAReportExampleMain
