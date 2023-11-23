. $VIM_HOME/bin/task-init.sh

RUST_ENV=$VIM_FILEDIR/.rust_env.sh
if [[ -f $RUST_ENV ]];then
  . $RUST_ENV
fi

if [[ -z $ROOT ]];then
  BASE_DIR=$VIM_FILEDIR
else
  BASE_DIR=$ROOT
fi
cd $BASE_DIR
CARGO_TOML=$BASE_DIR/Cargo.toml
if [[ -f $CARGO_TOML ]];then
  cargo run $@
else
  echo "Cargo.toml not found"
fi
