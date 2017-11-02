#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi

ASTERIX_HOME="$PROJECT_HOME/asterixdb"

pushd "$ASTERIX_HOME/opt/ansible/bin" > /dev/null
	./stop.sh
popd > /dev/null
