#!/bin/bash

if [ "$1" == "" ]
then
	echo "Usage: ./query.sh similarity_threshold, e.g. ./query.sh 0.6"
	exit 1
fi
	
JACCARD=$1
SHINGLE=2

QUERY="statement = 
    USE test; 
    WITH Shingled as ( 
      SELECT ts.id as id, shingle2 as shingle 
      FROM TweetsSet ts 
      LET shingle1 = test.\`testlib#shingle\`(ts.text, $SHINGLE), 
      shingle2 = if_missing_or_null(shingle1, []) 
    ) 
    SELECT VALUE {{ s1.id, ids }} 
    FROM Shingled s1 
    LET ids = ( 
      SELECT VALUE s2.id 
      FROM Shingled s2 
      LET sim = to_double(similarity_jaccard(s1.shingle, s2.shingle)) 
      WHERE sim > to_double($JACCARD) AND s1.id != s2.id 
      ORDER BY {{ sim }} DESC 
    ); 
"
# note: "missing" is returned from shingle UDF when function returns empty list. Thus if_missing_or_null is used.

out=`curl --data-urlencode "$QUERY" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 

status=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['status']" || echo "python error"`
if [ "$status" != "success" ]
then
	echo "full response: $out"	
	echo "Line $LINENO: error - result status: $status";
	exit 1;
fi


echo $out | python -c "import sys, json; print json.dumps(json.load(sys.stdin)['results'])"
