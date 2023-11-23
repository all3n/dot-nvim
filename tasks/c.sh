. $VIM_HOME/bin/task-init.sh

SCRIPT=$1
: ${CFLAGS:=-std=c11}
: ${CC:=$(which gcc)}

if [[ -z $ROOT ]];then
  cd $VIM_FILEDIR
fi

if [[ -z $BUILD_RIR ]];then
  TMP_OUTPUT=$(get_temp_file_path)
  DELETE=1
else
  BUILD_DIR=$VIM_FILEDIR/$BUILD_DIR
  mkdir -p $BUILD_RIR
  NAME=$(basename $SCRIPT)
  NAME=${NAME%.*}
  TMP_OUTPUT=$BUILD_RIR/$NAME
  DELETE=0
fi
CMD="$CC -g $CFLAGS -o $TMP_OUTPUT $@ $SOURCES ${LDFLAGS} $LIBS"
echo $CMD
echo "--------------------------------------------------------"
$CMD
ulimit -c unlimited

$TMP_OUTPUT
if [[ $DELETE -eq 1 ]];then
  rm -f $TMP_OUTPUT
fi 
