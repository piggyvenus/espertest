#!/bin/sh

# Script to run the example JMX server
#

# A note to cygwin users: please replace "-cp ${CLASSPATH}" with "-cp `cygpath -wp $CLASSPATH`"
#

. ../../setenv.sh

MEMORY_OPTIONS="-Xms512m -Xmx512m -server -XX:+UseParNewGC"

# To enable the Sun JVM platform mbean connector, add the following options:
# -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false
#

$JAVA_HOME/bin/java $MEMORY_OPTIONS -Dlog4j.configuration=log4j.xml -cp ${CLASSPATH} com.espertech.esper.jmx.example.TrafficExampleServerMain $1 $2 $3
