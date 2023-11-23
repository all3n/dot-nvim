. $VIM_HOME/bin/task-init.sh

SCRIPT=$1
SCRIPT_NAME=$(basename $SCRIPT)
SCRIPT_DIR=$(cd $(dirname $SCRIPT);pwd)
# remove ext
SCRIPT_NAME=${SCRIPT_NAME%%.*}

if [[ -n $JAVA_HOME ]];then
    JAVAC=$JAVA_HOME/bin/javac
    JAVA=$JAVA_HOME/bin/java
else
    JAVAC=$(which javac)
    JAVA=$(which java)
fi

CLASSES_DIR=$SCRIPT_DIR/target/classes
mkdir -p $CLASSES_DIR
echo "java:$JAVA classes:$CLASSES_DIR"

$JAVAC -d $CLASSES_DIR $@
export CLASSPATH=$CLASSES_DIR
java $SCRIPT_NAME
