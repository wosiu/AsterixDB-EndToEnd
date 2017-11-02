#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

# todo install ansible
# todo build udf
# put udfs
pushd "$PROJECT_HOME/scripts"
	./start_asterix.sh || { echo "Error $LINENO"; exit 1; }
	./init_data.sh || { echo "Error $LINENO"; exit 1; }
popd

echo "Asterix is running, run script/stop_asterix.sh after you're done"
