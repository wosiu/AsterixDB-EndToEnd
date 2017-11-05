#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi


source "$PROJECT_HOME/scripts/commons.sh"
if isAsterixRunning
then
	
	echo "Asterix already running, skipping start..";
	exit 0;
fi

ASTERIX_HOME="$PROJECT_HOME/asterixdb"
pushd "$ASTERIX_HOME/opt/ansible/bin" > /dev/null
	./start.sh
popd > /dev/null

# it takes few seconds to become usable..
i=0
while [[ $i < 10 ]]
do
	if isAsterixRunning
	then
		exit 0
	fi
	sleep 1
	i=$[i+1]
done

if ! isAsterixRunning
then
	echo "Cannot start asterix"
	exit 1
fi
