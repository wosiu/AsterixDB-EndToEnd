#!/bin/bash

function isAsterixRunning() {
	out=`curl --data-urlencode "statement = SELECT VALUE 'ready';" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 
	result=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['results'][0]" 2>/dev/null || echo "python error"`
	[[ "$result" == "ready" ]]
}

