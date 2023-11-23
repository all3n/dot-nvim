set -e
. $VIM_HOME/bin/functions.sh
export TASK_HOME=$VIM_HOME/tasks
PROJECT_MVIM_CONFIG=$VIM_CWD/.mvim.sh
if [[ -f $PROJECT_MVIM_CONFIG ]];then
    . $PROJECT_MVIM_CONFIG
fi
if [[ -n $ROOT ]];then
  ROOT_MVIM=$ROOT/.mvim/init.sh
  if [[ -f $ROOT_MVIM ]];then
    . $ROOT_MVIM
  fi
fi
: ${BUILD_MODE:=single}
export WORKSPACE=$(find_root $VIM_CWD)
export ABS_FILE=$VIM_FILEPATH
export MODUEL_FILE_PATH=${ABS_FILE#$WORKSPACE/}
if [[ "$WORKSPACE" != "/" ]];then
  export WORKSPACE_ARGS=$WORKSPACE/.args
  RUN_ARGS=
  if [[ -f $WORKSPACE_ARGS ]];then
    RUN_ARGS=$(awk -v NAME="$MODUEL_FILE_PATH" '$1 == NAME { for(i=2; i<=NF; i++) printf("%s ", $i); print "" }' $WORKSPACE_ARGS)
  fi
  export RUN_ARGS
  
  WORKSPACE_ENV=$WORKSPACE/.env
  if [[ -f $WORKSPACE_ENV ]];then
    . $WORKSPACE_ENV
  fi
fi
if [[ "$BUILD_MODE" == "single" ]];then
  SCRIPT=$VIM_FILEPATH
  for line in $(cat $SCRIPT|grep -E "//\s*@ENV"|awk -F: '{print $2}');do 
    KEY=$(echo $line|awk -F= '{print $1}')
    VALUE=$(echo $line|awk '{print substr($0, index($0, "=") + 1)}')
    eval "export $KEY=$VALUE"
  done
fi
