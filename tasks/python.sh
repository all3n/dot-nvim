. $VIM_HOME/bin/task-init.sh

SCRIPT=$1

if [[ -z "$PYTHON" ]];then
  CWD_VENV=$WORKSPACE/venv
  if [[ -d $CWD_VENV ]];then
      . $CWD_VENV/bin/activate
      TASK_PYTHON=$(which python)
  fi
  if [[ -f $TASK_PYTHON ]];then
      PYTHON=$TASK_PYTHON
  else
      PYTHON=$(which python)
  fi
fi

echo "PYTHON: $PYTHON $@"

$PYTHON $@ $RUN_ARGS
