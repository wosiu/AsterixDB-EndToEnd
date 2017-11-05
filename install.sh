#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

proc=`jps -l | grep org.apache.hyracks.control | wc -l`

if [[ $proc > 0 ]]
then
	echo "Hyracks is running, stop previous asterix execution..";
	exit 1;
fi

# todo install ansible

pushd "$PROJECT_HOME/scripts"
	# TODO sysbanner..
	./install_asterix.sh || { echo "Error $LINENO"; exit 1; }
	./install_udfs.sh || { echo "Error $LINENO"; exit 1; }
	./start_asterix.sh || { echo "Error $LINENO"; exit 1; }
	./init_data.sh || { echo "Error $LINENO"; exit 1; }
popd

echo "Asterix is running, run script/stop_asterix.sh after you're done"
