JDTLS_URL="https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.29.0/jdt-language-server-1.29.0-202310261436.tar.gz"
VERSION=$(echo $JDTLS_URL|grep -E -o "[0-9.]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}"|head -n 1)
JDTLS_HOME=$HOME/opt/jdtls-$VERSION
TMP_TGZ=/tmp/jdtls-$VERSION.tar.gz
if [[ ! -d "$JDTLS_HOME" ]];then
  mkdir -p $JDTLS_HOME
  rm -f $TMP_TGZ
  wget $JDTLS_URL -O $TMP_TGZ
  tar -zxvf $TMP_TGZ -C $JDTLS_HOME
  rm -f $TMP_TGZ
fi


LOMBOK_URL="https://projectlombok.org/downloads/lombok.jar"
JDTLS_DATA=$HOME/.local/share/nvim/jdtls
mkdir -p $JDTLS_DATA
wget -O $JDTLS_DATA/lombok.jar $LOMBOK_URL
