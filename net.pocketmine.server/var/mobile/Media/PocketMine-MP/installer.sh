#!/bin/sh

#Needed to use aliases
shopt -s expand_aliases
type wget > /dev/null 2>&1
if [ $? -eq 0 ]; then
	alias download_file="wget --no-check-certificate -q -O -"
else
	type curl >> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		alias download_file="curl --insecure --silent --location"
	else
		echo "error, curl or wget not found"
	fi
fi


while getopts "dv:" opt; do
  case $opt in
	d)
	  PMMP_VERSION="master"
      ;;
	v)
	  PMMP_VERSION="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
	  exit 1
      ;;
  esac
done

if [ "$PMMP_VERSION" == "" ]; then
	PMMP_VERSION=$(download_file "https://api.github.com/repos/PocketMine/PocketMine-MP/tags" | grep '"name": "[A-Za-z0-9_\.]*",' | head -1 | sed -r 's/[ ]*"name": "([A-Za-z0-9_\.]*)",[ ]*/\1/')
	if [ "$PMMP_VERSION" == "" ]; then
		echo "[ERROR] Couldn't get the latest PocketMine-MP version"
		exit 1
	fi
fi

echo "[INFO] PocketMine-MP $PMMP_VERSION installer"

echo "[1/2] Cleaning..."
rm -r -f src/
rm -f PocketMine-MP.php
rm -f README.md
rm -f CONTRIBUTING.md
rm -f LICENSE
rm -f start.sh
rm -f start.bat
echo "[2/2] Downloading PocketMine-MP $PMMP_VERSION..."
set -e
download_file "https://github.com/PocketMine/PocketMine-MP/archive/$PMMP_VERSION.tar.gz" | tar -zx > /dev/null
mv -f PocketMine-MP-$PMMP_VERSION/* ./
rm -f -r PocketMine-MP-$PMMP_VERSION/
rm -f ./start.cmd
chmod +x ./start.sh
chmod +x ./src/build/compile.sh
echo "[INFO] Everything done! Run /var/mobile/Media/PocketMine-MP/start.sh to start PocketMine-MP"
exit 0
