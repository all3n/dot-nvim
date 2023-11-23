. $VIM_HOME/bin/task-init.sh
export ROOT=$(find_root $VIM_FILEDIR)
if [[ -n "$ROOT" ]];then
  echo "ROOT:$ROOT"
  cd $ROOT
fi

export EXEC_LIST=()
exec_dir(){
  find_exec $1
  EXEC_NUM=${#EXEC_LIST[@]}
  if [[ $EXEC_NUM -eq 0 ]];then
    echo "NOT FOUND EXECUTABLE FILE"
  elif [[ $EXEC_NUM -eq 1 ]];then
    echo "BIN:$EXEC_LIST"
    echo "------------------------------------------------"
    $EXEC_LIST
  else
    for idx in `seq 0 $(( EXEC_NUM -1 ))`;do
      echo "index:$idx  "${EXEC_LIST[$idx]}
    done
    echo "input index:"
    read INDEX
    EXEC=${EXEC_LIST[$INDEX]}
    echo "BIN:$EXEC"
    echo "------------------------------------------------"
    $EXEC
  fi
}

EXT=${VIM_FILEPATH##*.}
EXT_SCRIPT=$TASK_HOME/$EXT.sh
EXT_TYPE=$(get_ext_type $EXT)
if [[ "$EXT" == "java" ]];then
    TMP_DIR=$(mktemp -d)
    MAIN_CLASS=$(cat $VIM_FILEPATH|grep class|grep -E -o 'class\s(\w+)'|awk -F" " '{print $2}'|head -n 1)
    javac $VIM_FILEPATH -d $TMP_DIR
    java -cp $TMP_DIR $MAIN_CLASS $@
    rm -rf $TMP_DIR
elif [[ -f $TASK_HOME/$EXT_TYPE.sh ]];then
    bash $TASK_HOME/$EXT_TYPE.sh $VIM_FILEPATH $@
fi
