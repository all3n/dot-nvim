. $VIM_HOME/bin/task-init.sh
: ${CXX:=g++}
TMP_OUTPUT=$(get_temp_file_path)
CMD="$CXX $CXXFLAGS -o $TMP_OUTPUT $@ $LIBS"
echo $CMD
echo "--------------------------------------------------------"
$CMD
$TMP_OUTPUT
rm $TMP_OUTPUT
