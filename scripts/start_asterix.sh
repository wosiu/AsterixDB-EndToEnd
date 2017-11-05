#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi


function isAsterixRunning() {
	out=`curl --data-urlencode "statement = SELECT VALUE 'ready';" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 
	result=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['results'][0]" 2>/dev/null || echo "python error"`
	[[ "$result" == "ready" ]]
}


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
