#!/bin/bash
# Load the sample data into 

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

PACKAGE_NAME=asterix-server-0.9.2-binary-assembly
ASTERIX_PATH="$PROJECT_HOME/asterixdb"

pushd "$PROJECT_HOME" > /dev/null
	mkdir -p download 
	pushd download > /dev/null
		if [ ! -f "$PACKAGE_NAME.zip" ]
		then
			wget http://ftp.ps.pl/pub/apache/asterixdb/asterixdb-0.9.2/$PACKAGE_NAME.zip \
				|| { echo "Error while downloading $PACKAGE_NAME"; exit 1; }
			rm -rf $ASTERIX_PATH 
		else
			echo "$PACKAGE_NAME already downloaded, using previous one. Remove manually if want to force download"
		fi	
		if [ ! -d $ASTERIX_PATH ]
		then
			unzip $PACKAGE_NAME.zip -d $ASTERIX_PATH || { echo "Error while unzipping $PACKAGE_NAME"; exit 1; }
		else
			echo "Asterix already installed, rm -rf $ASTERIX_PATH to force fresh Asterix. Skipping..";
		fi		
	popd > /dev/null
popd > /dev/null

pushd "$ASTERIX_PATH/opt/ansible/bin" > /dev/null
	# clone folder to all machines, in our case copy to localhost to a current user's direcotry		
	./deploy.sh || { echo "Error while deploying"; exit 1; }
popd > /dev/null

