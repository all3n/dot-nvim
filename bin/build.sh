. $VIM_HOME/bin/task-init.sh
export ROOT=$(find_root $VIM_FILEDIR)
cd $ROOT
if [[ -f $ROOT/CMakeLists.txt ]];then
  bash cmake.sh
elif [[ -f $ROOT/Makefile ]] || [[ -f $ROOT/makefile ]];then
  bash make.sh
elif [[ -f $ROOT/SConstruct ]];then
  scons -j$(nproc)
elif [[ -f $ROOT/pom.xml ]];then
  bash maven.sh
elif [[ -f $ROOT/Cargo.toml ]];then
  cargo build
fi
