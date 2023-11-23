. $VIM_HOME/bin/task-init.sh
export ROOT=$(find_root $VIM_FILEDIR)
if [[ -n "$ROOT" ]];then
  echo "ROOT:$ROOT"
  cd $ROOT
else
  ROOT=$VIM_FILEDIR
fi

export EXEC_LIST=()
exec_dir(){
  find_exec $1
  shift
  EXEC_NUM=${#EXEC_LIST[@]}
  if [[ $EXEC_NUM -eq 0 ]];then
    echo "NOT FOUND EXECUTABLE FILE"
  elif [[ $EXEC_NUM -eq 1 ]];then
    echo "BIN:$EXEC_LIST"
    echo "------------------------------------------------"
    $EXEC_LIST $@
  else
    for idx in `seq 0 $(( EXEC_NUM -1 ))`;do
      echo "index:$idx  "${EXEC_LIST[$idx]}
    done
    echo "input index:"
    read INDEX
    EXEC=${EXEC_LIST[$INDEX]}
    echo "BIN:$EXEC"
    echo "------------------------------------------------"
    $EXEC $@
  fi
}


BUILD_DIR=$ROOT/build
if [[ -d $BUILD_DIR ]];then
  exec_dir $ROOT/build $@
else
  echo "not support"
fi
