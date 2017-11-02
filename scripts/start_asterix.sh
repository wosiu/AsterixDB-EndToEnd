#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi

proc=`jps -l | grep org.apache.hyracks.control | wc -l`

if [[ $proc > 0 ]]
then
	echo "Asterix already running, skipping..";
	exit 0;
fi

ASTERIX_HOME="$PROJECT_HOME/asterixdb"
pushd "$ASTERIX_HOME/opt/ansible/bin" > /dev/null
	./start.sh
popd > /dev/null
