#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi

function getAsterixProcNum() {
	echo `jps -l | grep org.apache.hyracks.control | wc -l`
}

if [[ `getAsterixProcNum` > 0 ]]
then
	echo "Asterix already running, skipping start..";
	exit 0;
fi

ASTERIX_HOME="$PROJECT_HOME/asterixdb"
pushd "$ASTERIX_HOME/opt/ansible/bin" > /dev/null
	./start.sh
popd > /dev/null

i=1
while [[ `getAsterixProcNum` < 3 && $i < 10 ]]
do
	sleep 1
	i=$[i+1]
done

if [[ `getAsterixProcNum` < 3 ]]
then
	echo "Cannot start asterix"
	exit 1
fi
