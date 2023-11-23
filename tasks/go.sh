. $VIM_HOME/bin/task-init.sh

GO_ENV=$VIM_FILEDIR/.go_env.sh
if [[ -f $GO_ENV ]];then
  . $GO_ENV
fi

if [[ -z $ROOT ]];then
  BASE_DIR=$VIM_FILEDIR
else
  BASE_DIR=$ROOT
fi
cd $BASE_DIR
go run .
