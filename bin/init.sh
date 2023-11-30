. $VIM_HOME/bin/functions.sh
# local config
MY_CONFIG=$VIM_HOME/bin/config.local.sh
if [[ -f $MY_CONFIG ]];then
    . $MY_CONFIG
fi

export TASKS_HOME=$VIM_HOME/tasks
export PATH=$TASKS_HOME:$PATH
