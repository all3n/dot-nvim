@echo off

set EXT=%VIM_FILETYPE%
set EXT_SCRIPT=%VIM_HOME%\tasks\%EXT%.cmd

set LANG_TYPE=
set RUN_BIN=
set OPTIONS=
if "%EXT%"=="c" (
  set LANG_TYPE=c
  set RUN_BIN=gcc.exe
) else if "%EXT%" == "cpp" (
  set LANG_TYPE=c
  set RUN_BIN=g++.exe
  set OPTIONS="-static-libstdc++"
) else if "%EXT%" == "py" (
  set LANG_TYPE=py
  set RUN_BIN=python.exe
) else if "%EXT%" == "java" (
  set LANG_TYPE=java
  set RUN_BIN=java.exe
)

if "%VIM_FILETYPE%"=="java" (
  set TMP_DIR="%TEMP%\nvim_build_%VIM_FILETYPE%_%RANDOM%"
  mkdir %TMP_DIR%
  set MAIN_CLASS=
  for /f "tokens=2" %%A in ('type "%VIM_FILEPATH%" ^| findstr /r /c:"class\s[[:alnum:]_]*"') do (
    if not defined MAIN_CLASS set MAIN_CLASS=%%A
  )
  javac "%VIM_FILEPATH%" -d "%TMP_DIR%"
  java -cp "%TMP_DIR%" %MAIN_CLASS% %*
  rd /s /q "%TMP_DIR%"
) else if "%LANG_TYPE%" == "c" (
  echo "%RUN_BIN% %VIM_FILEPATH% %OPTIONS% -o %VIM_FILEDIR%\main.exe"
  %RUN_BIN% %VIM_FILEPATH% %OPTIONS% -o %VIM_FILEDIR%\main.exe
  %VIM_FILEDIR%\main.exe %*
) else if "%EXT%" == "python" (
  python %VIM_FILEPATH% %*
) else if exist "%EXT_SCRIPT%" (
  call "%EXT_SCRIPT%" "%VIM_FILEPATH%" %*
)
