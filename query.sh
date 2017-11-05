#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

INSTALL_ENV="$PROJECT_HOME/env"

source $INSTALL_ENV/bin/activate

pushd "$PROJECT_HOME/scripts" > /dev/null
	./start_asterix.sh
	# todo while true, sleep	
	./single_query.sh $1
	./stop_asterix.sh
popd > /dev/null

deactivate
