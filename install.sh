#!/bin/bash

# Download, install and run the asterix db in the current directory (it needs to work in lab) and load the sample data into it

pushd `dirname $0` > /dev/null
HOME=`pwd -P`
popd > /dev/null

# ========================= LOAD SAMPLE DATA ====================================

QUERY="statement = "
QUERY+="CREATE DATAVERSE test IF NOT EXISTS;"
QUERY+="USE test;"
QUERY+="CREATE TYPE Tweet IF NOT EXISTS AS OPEN { id : int, text: string };"
QUERY+="DROP DATASET TweetsSet IF EXISTS;"
QUERY+="CREATE DATASET TweetsSet(Tweet) primary key id;"
QUERY+="load dataset TweetsSet using localfs (('path'='localhost:///$HOME/tweets/initial_tweets.csv'), ('format'='delimited-text'), ('header'='true'), ('delimiter'=','));"
QUERY+="drop feed TweetsFeed if exists;"
QUERY+="create feed TweetsFeed if not exists using localfs (('type-name'='Tweet'), ('path'='localhost:///$HOME/tweets/tweets_feed'), ('format'='delimited-text'));"
QUERY+="connect feed TweetsFeed to dataset TweetsSet;"

out=`curl --data-urlencode "$QUERY" --data mode=immediate http://localhost:19002/query/service 2>/dev/null` 
#status=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['status']"`

status=`echo $out | python -c "import sys, json; print json.load(sys.stdin)['status']" || echo "python error"`

if [ "$status" != "success" ]
then
	echo "Line $LINENO: error - result status: $status";
	echo "full response: $out"	
	exit 1;
fi

echo "OK"
