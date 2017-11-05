#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

source "$PROJECT_HOME/scripts/commons.sh"
if isAsterixRunning
then
	
	echo "Asterix is running, stop previous instance..";
	exit 1;
fi

# todo install ansible

pushd "$PROJECT_HOME/scripts"
	# TODO sysbanner..
	echo "============== INSTALLING ASTERIX ==========="
	./install_asterix.sh || { echo "Error $LINENO"; exit 1; }
	echo "=============== INSTALLING UDFS ============="
	./install_udfs.sh || { echo "Error $LINENO"; exit 1; }
	echo "============== STARTING ASTERIX ============="
	./start_asterix.sh || { echo "Error $LINENO"; exit 1; }
	echo "============= INITIALIZING DATA ============="
	./init_data.sh || { echo "Error $LINENO"; exit 1; }
popd

echo "Asterix is running, run script/stop_asterix.sh after you're done"
