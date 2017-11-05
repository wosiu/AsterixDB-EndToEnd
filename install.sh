#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

function isAsterixRunning() {
	out=`curl --data-urlencode "statement = SELECT VALUE 'ready';" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 
	result=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['results'][0]" 2>/dev/null || echo "python error"`
	[[ "$result" == "ready" ]]
}


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
