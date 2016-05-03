#!/bin/sh

# -----------------------------------------------------------------------------
# Start/Stop Script for the ESPEREE Server
#
# Environment Variable Prequisites
#
#   ESPEREE_HOME   May point at your EsperEE directory.
#
#   ESPEREE_BASE   (Optional) Base directory for resolving dynamic portions
#                   of a EsperEE installation, if any.  If not present, resolves to
#                   the same directory that ESPEREE_HOME points to.
#
#   ESPEREE_OPTS   (Optional) Java runtime options used when the "start",
#                   or "run" command is executed.
#
#   ESPEREE_TMPDIR (Optional) Directory path location of temporary directory
#                   the JVM should use (java.io.tmpdir).  Defaults to
#                   $ESPEREE_BASE/temp.
#
#   JAVA_HOME       Must point at your Java Development Kit installation.
#                   Required to run the with the "debug" or "javac" argument.
#
#   JRE_HOME        Must point at your Java Development Kit installation.
#                   Defaults to JAVA_HOME if empty.
#
#   JAVA_OPTS       (Optional) Java runtime options used when the "start",
#                   "stop", or "run" command is executed.
#
#   JPDA_TRANSPORT  (Optional) JPDA transport used when the "jpda start"
#                   command is executed. The default is "dt_socket".
#
#   JPDA_ADDRESS    (Optional) Java runtime options used when the "jpda start"
#                   command is executed. The default is 8000.
#
#   JPDA_SUSPEND    (Optional) Java runtime options used when the "jpda start"
#                   command is executed. Specifies whether JVM should suspend
#                   execution immediately after startup. Default is "n".
#
#   JPDA_OPTS       (Optional) Java runtime options used when the "jpda start"
#                   command is executed. If used, JPDA_TRANSPORT, JPDA_ADDRESS,
#                   and JPDA_SUSPEND are ignored. Thus, all required jpda
#                   options MUST be specified. The default is:
#
#                   -agentlib:jdwp=transport=$JPDA_TRANSPORT,
#                       address=$JPDA_ADDRESS,server=y,suspend=$JPDA_SUSPEND
#
#   JSSE_HOME       (Optional) May point at your Java Secure Sockets Extension
#                   (JSSE) installation, whose JAR files will be added to the
#                   system class path used to start.
#
#   ESPEREE_PID    (Optional) Path of the file which should contains the pid
#                   of EsperEE startup java process, when start (fork) is used
#
#   LOGGING_CONFIG  (Optional) Override Log4j logging config file
#                   Example (all one line)
#                   LOGGING_CONFIG="-Djava.util.logging.config.file=$ESPEREE_BASE/conf/logging.properties"
#
# -----------------------------------------------------------------------------

# OS specific support.  $var _must_ be set to either true or false.
cygwin=false
os400=false
darwin=false
case "`uname`" in
CYGWIN*) cygwin=true;;
OS400*) os400=true;;
Darwin*) darwin=true;;
esac

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set ESPEREE_HOME if not already set
[ -z "$ESPEREE_HOME" ] && ESPEREE_HOME=`cd "$PRGDIR/.." ; pwd`

if [ -r "$ESPEREE_BASE"/bin/setenv.sh ]; then
  . "$ESPEREE_BASE"/bin/setenv.sh
elif [ -r "$ESPEREE_HOME"/bin/setenv.sh ]; then
  . "$ESPEREE_HOME"/bin/setenv.sh
fi

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin; then
  [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
  [ -n "$JRE_HOME" ] && JRE_HOME=`cygpath --unix "$JRE_HOME"`
  [ -n "$ESPEREE_HOME" ] && ESPEREE_HOME=`cygpath --unix "$ESPEREE_HOME"`
  [ -n "$ESPEREE_BASE" ] && ESPEREE_BASE=`cygpath --unix "$ESPEREE_BASE"`
  [ -n "$CLASSPATH" ] && CLASSPATH=`cygpath --path --unix "$CLASSPATH"`
  [ -n "$JSSE_HOME" ] && JSSE_HOME=`cygpath --absolute --unix "$JSSE_HOME"`
fi

# For OS400
if $os400; then
  # Set job priority to standard for interactive (interactive - 6) by using
  # the interactive priority - 6, the helper threads that respond to requests
  # will be running at the same priority as interactive jobs.
  COMMAND='chgjob job('$JOBNAME') runpty(6)'
  system $COMMAND

  # Enable multi threading
  export QIBM_MULTI_THREADED=Y
fi

# Get standard Java environment variables
if $os400; then
  # -r will Only work on the os400 if the files are:
  # 1. owned by the user
  # 2. owned by the PRIMARY group of the user
  # this will not work if the user belongs in secondary groups
  BASEDIR="$ESPEREE_HOME"
  . "$ESPEREE_HOME"/bin/setclasspath.sh 
else
  if [ -r "$ESPEREE_HOME"/bin/setclasspath.sh ]; then
    BASEDIR="$ESPEREE_HOME"
    . "$ESPEREE_HOME"/bin/setclasspath.sh
  else
    echo "Cannot find $ESPEREE_HOME/bin/setclasspath.sh"
    echo "This file is needed to run this program"
    exit 1
  fi
fi

# Add on extra jar files to CLASSPATH
if [ -n "$JSSE_HOME" ]; then
  CLASSPATH="$CLASSPATH":"$JSSE_HOME"/lib/jcert.jar:"$JSSE_HOME"/lib/jnet.jar:"$JSSE_HOME"/lib/jsse.jar
fi
CLASSPATH="$CLASSPATH":"$ESPEREE_HOME"/bin/bootstrap.jar

if [ -z "$ESPEREE_BASE" ] ; then
  ESPEREE_BASE="$ESPEREE_HOME"
fi

if [ -z "$ESPEREE_TMPDIR" ] ; then
  # Define the java.io.tmpdir to use
  ESPEREE_TMPDIR="$ESPEREE_BASE"/temp
fi

# Bugzilla 37848: When no TTY is available, don't output to console
have_tty=0
if [ "`tty`" != "not a tty" ]; then
    have_tty=1
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  JAVA_HOME=`cygpath --absolute --windows "$JAVA_HOME"`
  JRE_HOME=`cygpath --absolute --windows "$JRE_HOME"`
  ESPEREE_HOME=`cygpath --absolute --windows "$ESPEREE_HOME"`
  ESPEREE_BASE=`cygpath --absolute --windows "$ESPEREE_BASE"`
  ESPEREE_TMPDIR=`cygpath --absolute --windows "$ESPEREE_TMPDIR"`
  CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
  [ -n "$JSSE_HOME" ] && JSSE_HOME=`cygpath --absolute --windows "$JSSE_HOME"`
  JAVA_ENDORSED_DIRS=`cygpath --path --windows "$JAVA_ENDORSED_DIRS"`
fi

# Set juli LogManager config file if it is present and an override has not been issued
if [ -z "$LOGGING_CONFIG" ]; then
  if [ -r "$ESPEREE_BASE"/conf/logging.properties ]; then
    LOGGING_CONFIG="-Djava.util.logging.config.file=$ESPEREE_BASE/conf/logging.properties"
  else
    LOGGING_CONFIG="-Dlog4j.configuration=log4j.xml"
  fi
fi

if [ -z "$ESPEREE_OPTS" ] ; then
  # Define the default memory requirements
  ESPEREE_OPTS="-Xms128m -Xmx1024m -javaagent:$ESPEREE_BASE/lib/esper-eeutilagent-5.3.0.jar"
fi

# ----- Execute The Requested Command -----------------------------------------

# Bugzilla 37848: only output this if we have a TTY
if [ $have_tty -eq 1 ]; then
  echo "Using ESPEREE_BASE:   $ESPEREE_BASE"
  echo "Using ESPEREE_HOME:   $ESPEREE_HOME"
  echo "Using ESPEREE_TMPDIR: $ESPEREE_TMPDIR"
  echo "Using ESPEREE_OPTS:   $ESPEREE_OPTS"
  if [ "$1" = "debug" -o "$1" = "javac" ] ; then
    echo "Using JAVA_HOME:       $JAVA_HOME"
  else
    echo "Using JRE_HOME:       $JRE_HOME"
  fi
fi

if [ "$1" = "jpda" ] ; then
  if [ -z "$JPDA_TRANSPORT" ]; then
    JPDA_TRANSPORT="dt_socket"
  fi
  if [ -z "$JPDA_ADDRESS" ]; then
    JPDA_ADDRESS="8000"
  fi
  if [ -z "$JPDA_SUSPEND" ]; then
    JPDA_SUSPEND="n"
  fi
  if [ -z "$JPDA_OPTS" ]; then
    JPDA_OPTS="-agentlib:jdwp=transport=$JPDA_TRANSPORT,address=$JPDA_ADDRESS,server=y,suspend=$JPDA_SUSPEND"
  fi
  ESPEREE_OPTS="$ESPEREE_OPTS $JPDA_OPTS"
  shift
fi

if [ "$1" = "debug" ] ; then
  if $os400; then
    echo "Debug command not available on OS400"
    exit 1
  else
    shift
    if [ "$1" = "-security" ] ; then
      echo "Using Security Manager"
      shift
      exec "$_RUNJDB" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
        -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
        -sourcepath "$ESPEREE_HOME"/../../java \
        -Djava.security.manager \
        -Djava.security.policy=="$ESPEREE_BASE"/conf/esperee.policy \
        -Desperee.base="$ESPEREE_BASE" \
        -Desperee.home="$ESPEREE_HOME" \
        -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
        com.espertech.esper.server.Bootstrap "$@" start
    else
      exec "$_RUNJDB" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
        -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
        -sourcepath "$ESPEREE_HOME"/../../java \
        -Desperee.base="$ESPEREE_BASE" \
        -Desperee.home="$ESPEREE_HOME" \
        -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
        com.espertech.esper.server.Bootstrap "$@" start
    fi
  fi

elif [ "$1" = "run" -o "$1" = "instrumented" ]; then

  shift
  if [ "$1" = "-security" ] ; then
    echo "Using Security Manager"
    shift
    exec "$_RUNJAVA" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
      -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
      -Djava.security.manager \
      -Djava.security.policy=="$ESPEREE_BASE"/conf/esperee.policy \
      -Desperee.base="$ESPEREE_BASE" \
      -Desperee.home="$ESPEREE_HOME" \
      -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
      com.espertech.esper.server.Bootstrap "$@" start
  else
    exec "$_RUNJAVA" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
      -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
      -Desperee.base="$ESPEREE_BASE" \
      -Desperee.home="$ESPEREE_HOME" \
      -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
      com.espertech.esper.server.Bootstrap "$@" start
  fi

elif [ "$1" = "start" ] ; then

  shift
  touch "$ESPEREE_BASE"/logs/esperee.out
  if [ "$1" = "-security" ] ; then
    echo "Using Security Manager"
    shift
    "$_RUNJAVA" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
      -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
      -Djava.security.manager \
      -Djava.security.policy=="$ESPEREE_BASE"/conf/esperee.policy \
      -Desperee.base="$ESPEREE_BASE" \
      -Desperee.home="$ESPEREE_HOME" \
      -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
      com.espertech.esper.server.Bootstrap "$@" start \
      >> "$ESPEREE_BASE"/logs/esperee.out 2>&1 &

      if [ ! -z "$ESPEREE_PID" ]; then
        echo $! > $ESPEREE_PID
      fi
  else
    "$_RUNJAVA" "$LOGGING_CONFIG" $JAVA_OPTS $ESPEREE_OPTS \
      -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
      -Desperee.base="$ESPEREE_BASE" \
      -Desperee.home="$ESPEREE_HOME" \
      -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
      com.espertech.esper.server.Bootstrap "$@" start \
      >> "$ESPEREE_BASE"/logs/esperee.out 2>&1 &

      if [ ! -z "$ESPEREE_PID" ]; then
        echo $! > $ESPEREE_PID
      fi
  fi

elif [ "$1" = "stop" ] ; then

  shift
  FORCE=0
  if [ "$1" = "-force" ]; then
    shift
    FORCE=1
  fi

  "$_RUNJAVA" $JAVA_OPTS \
    -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" -classpath "$CLASSPATH" \
    -Desperee.base="$ESPEREE_BASE" \
    -Desperee.home="$ESPEREE_HOME" \
    -Djava.io.tmpdir="$ESPEREE_TMPDIR" \
    com.espertech.esper.server.Bootstrap "$@" stop

  if [ $FORCE -eq 1 ]; then
    if [ ! -z "$ESPEREE_PID" ]; then
       echo "Killing: `cat $ESPEREE_PID`"
       kill -9 `cat $ESPEREE_PID`
    else
       echo "Kill failed: \$ESPEREE_PID not set"
    fi
  fi

elif [ "$1" = "version" ] ; then

    "$_RUNJAVA"   \
      com.espertech.esper.server.ServerInfo

else

  echo "Usage: esperee.sh ( commands ... )"
  echo "commands:"
  if $os400; then
    echo "  debug             Start EsperEE in a debugger (not available on OS400)"
    echo "  debug -security   Debug EsperEE with a security manager (not available on OS400)"
  else
    echo "  debug             Start EsperEE in a debugger"
    echo "  debug -security   Debug EsperEE with a security manager"
  fi
  echo "  jpda start        Start EsperEE under JPDA debugger"
  echo "  run               Start EsperEE in the current window"
  echo "  run -security     Start in the current window with security manager"
  echo "  start             Start EsperEE in a separate window"
  echo "  start -security   Start in a separate window with security manager"
  echo "  stop              Stop EsperEE"
  echo "  stop -force       Stop EsperEE (followed by kill -KILL)"
  echo "  instrumented      Start EsperEE instrumented for use with EPL debugger"
  echo "  version           What version of EsperEE are you running?"
  exit 1

fi
