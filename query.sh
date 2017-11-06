#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	(>&2 echo "STOPPING..")
	$PROJECT_HOME/scripts/stop_asterix.sh 1>/dev/null 2>/dev/null || { echo "Error while stopping asterix"; exit 1; }
	exit 0
}

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

INSTALL_ENV="$PROJECT_HOME/env"
INTERVAL=5s

source $INSTALL_ENV/bin/activate

pushd "$PROJECT_HOME/scripts" > /dev/null
	./start_asterix.sh 1>/dev/null 2>/dev/null || { echo "Error while starting asterix"; exit 1; }
	# todo while true, sleep
	while true
	do	
		(>&2 date +"%F %T")
		./single_query.sh $1 || { echo "Error while quering"; exit 1; }
		sleep $INTERVAL	
	done


