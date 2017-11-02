#!/bin/bash

if [ "$1" == "" ]
then
	echo "Usage: ./query.sh similarity_threshold, e.g. ./query.sh 0.6"
	exit 1
fi
	
JACCARD=$1
SHINGLE=2

QUERY="statement = "
QUERY+="USE test;"
QUERY+="start feed TweetsFeed;"
QUERY+="SELECT VALUE {{ t1.id, ids }} "
QUERY+="FROM TweetsSet t1 "
QUERY+="LET"
QUERY+="    shng1 = test.\`testlib#shingle\`(t1.text, $SHINGLE), "
QUERY+="    ids = "
QUERY+="    ( "
QUERY+="         SELECT VALUE t2.id  "
QUERY+="         FROM TweetsSet t2 "
QUERY+="         LET "
QUERY+="             shng2 = test.\`testlib#shingle\`(t2.text, $SHINGLE), "
QUERY+="             sim = (similarity_jaccard(shng1, shng2) > $JACCARD)"
QUERY+="         WHERE sim AND t1.id != t2.id "
QUERY+="    ); "

out=`curl --data-urlencode "$QUERY" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 

status=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['status']" || echo "python error"`
if [ "$status" != "success" ]
then
	echo "full response: $out"	
	echo "Line $LINENO: error - result status: $status";
	exit 1;
fi


echo $out | python -c "import sys, json; print json.dumps(json.load(sys.stdin)['results'])"
