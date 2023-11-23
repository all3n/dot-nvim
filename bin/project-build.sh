export BUILD_MODE=project
. $VIM_HOME/bin/task-init.sh
export ROOT=$(find_root $VIM_FILEDIR)
if [[ "$ROOT" != "" && "$ROOT" != "/" ]];then
  cd $ROOT
else
  ROOT=$VIM_FILEDIR
fi


build_by_ext(){
  EXT=${VIM_FILEPATH##*.}
  EXT_TYPE=$(get_ext_type $EXT)
  if [[ "$EXT_TYPE" == "c" ]];then
    make -f $VIM_HOME/configs/Makefile -C $VIM_FILEDIR build_dir all $@
  fi
}


if [[ -f $ROOT/CMakeLists.txt ]];then
  bash $TASK_HOME/cmake.sh $@
elif [[ -f $ROOT/Makefile ]] || [[ -f $ROOT/makefile ]];then
  bash $TASK_HOME/make.sh $@
elif [[ -f $ROOT/SConstruct ]];then
  scons -j$(nproc) $@
elif [[ -f $ROOT/pom.xml ]];then
  bash $TASK_HOME/maven.sh $@
elif [[ -f $ROOT/Cargo.toml ]];then
  cargo build $@
else
  build_by_ext $@
fi
