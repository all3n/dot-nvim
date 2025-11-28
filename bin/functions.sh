function get_os(){
    if [[ "$(uname)" == "Darwin" ]];then
        echo "MAC"
    elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]];then
        echo "LINUX"
    fi
}
function get_nproc(){
    if [[ "$(get_os)" == "MAC" ]];then
        echo "$(sysctl -n hw.ncpu)"
    elif [[ "$(get_os)" == "LINUX" ]];then
        echo "$(nproc)"
    fi
}

function get_nvim(){
    echo "$NVIM_BIN"
 }

function get_real_path() {
  local path="$1"
  local dir="$(dirname "$path")"
  local name="$(basename "$path")"
  local real_path=""
  cd "$dir" || return 1
  while [ -L "$name" ]; do
    name="$(readlink "$name")"
    cd "$(dirname "$name")" || return 1
    real_path="$(pwd -P)/$(basename "$name")"
    name="$(basename "$real_path")"
  done
  real_path="$(pwd -P)/$name"
  echo "$real_path"
}

function setup_venv(){
    echo 1
}

function get_temp_file_path() {
    local temp_file_path=$(mktemp)
    trap "rm -f $temp_file_path" EXIT
    echo $temp_file_path
}
function get_temp_dir() {
    local temp_file_path=$(mktemp -d)
    trap "rm -rf $temp_file_path" EXIT
    echo $temp_file_path
}

function find_root(){
  dir=$(get_real_path $1)
   while [[ "$dir" != "/" ]]; do
       if [[ -e "$dir/.root" ]] || [[ -e "$dir/.project" ]] || [[ -d "$dir/.git" ]] || [[ -e "$dir/.hg" ]]; then
           echo "$dir"
           return 
       fi
       dir=$(dirname "$dir")
   done
}


function find_exec(){
  dir=$1
  for file in "$dir"/*; do
    if [[ -x "$file" && -f "$file" ]]; then
        EXEC_LIST+=("$file")
    fi
  done
}


function get_sources(){
  local script_dir=$(cd $(dirname $(get_real_path $1));pwd)
  local sources=$(grep -Eo 'src/.*\.(cpp|c|cc|c')
  echo $sources
}



function get_ext_type(){
  local EXT=$1
  if [[ "$EXT" == "rs" ]];then
    EXT="rust"
  elif [[ "$EXT" == "cc" ]];then
    EXT="cpp"
  elif [[ "$EXT" == "py" ]];then
    EXT="python"
  fi
  echo $EXT
}
