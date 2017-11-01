#!/bin/bash


QUERY="statement = "
QUERY+="USE test;"
QUERY+="start feed TweetsFeed;"
QUERY+="SELECT id, test.\`testlib#shingle\`(text, 2) as shingle FROM TweetsSet;"

#echo "'${QUERY}'"

out=`curl --data-urlencode "$QUERY" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 

status=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['status']" || echo "python error"`
if [ "$status" != "success" ]
then
	echo "Line $LINENO: error - result status: $status";
	echo "full response: $out"	
	exit 1;
fi


echo $out | python -c "import sys, json; print json.load(sys.stdin)['results']"
