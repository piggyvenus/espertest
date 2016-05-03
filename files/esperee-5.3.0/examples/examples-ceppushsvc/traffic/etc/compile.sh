#!/bin/sh

# A note to cygwin users: please replace "-cp ${CLASSPATH}" with "-cp `cygpath -wp $CLASSPATH`"
#

. ../../setenv.sh

if [ ! -d "../target" ]
then
    mkdir ../target
fi
if [ ! -d "../target/classes" ]
then
    mkdir ../target/classes
fi

SOURCEPATH=../src/main/java

${JAVA_HOME}/bin/javac -cp ${CLASSPATH} -d ../target/classes -source 1.7 -sourcepath ${SOURCEPATH} ${SOURCEPATH}/com/espertech/esper/ceppushsvc/examples/traffic/client/SampleTrafficMonitorClient.java ${SOURCEPATH}/com/espertech/esper/ceppushsvc/examples/traffic/server/SampleTrafficMonitorServer.java
