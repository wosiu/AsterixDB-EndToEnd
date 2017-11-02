#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

# todo wget asterixdb
# todo install ansible

pushd "$PROJECT_HOME/scripts"
	# TODO sysbanner..	
	./install_udfs.sh || { echo "Error $LINENO"; exit 1; }
	./start_asterix.sh || { echo "Error $LINENO"; exit 1; }
	./init_data.sh || { echo "Error $LINENO"; exit 1; }
popd

echo "Asterix is running, run script/stop_asterix.sh after you're done"
