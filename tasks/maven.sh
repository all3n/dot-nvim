. $VIM_HOME/bin/task-init.sh
MVNW=$ROOT/mvnw
MVN=mvn
if [[ -f $MVNW ]];then
  MVN=$MVNW
fi

$MVN compile $@
