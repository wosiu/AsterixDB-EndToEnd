#!/bin/bash
# Load the sample data into 

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

PACKAGE_NAME=asterix-server-0.9.2-binary-assembly

pushd "$PROJECT_HOME" > /dev/null
	mkdir -p download 
	pushd download > /dev/null
		if [ ! -f "$PACKAGE_NAME.zip" ]
		then
			wget http://ftp.ps.pl/pub/apache/asterixdb/asterixdb-0.9.2/$PACKAGE_NAME.zip \
				|| { echo "Error while downloading $PACKAGE_NAME"; exit 1; }
			rm -rf "$PROJECT_HOME/asterixdb" 
		else
			echo "$PACKAGE_NAME already downloaded, using previous one. Remove manually if want to force download"
		fi	
		if [ ! -d "$PROJECT_HOME/asterixdb" ]
		then
			unzip $PACKAGE_NAME.zip -d "$PROJECT_HOME/asterixdb" || { echo "Error while unzipping $PACKAGE_NAME"; exit 1; }
		else
			echo "Asterix already installed, rm -rf $PROJECT_HOME/asterixdb to force fresh Asterix. Skipping..";
		fi		
	popd > /dev/null
	pushd asterixdb/opt/ansible/bin > /dev/null
		# clone folder to all machines, in our case copy to localhost to a current user's direcotry		
		./deploy.sh
	popd > /dev/null
popd > /dev/null

