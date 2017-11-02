#!/bin/bash

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0`/.. > /dev/null
	PROJECT_HOME="`pwd -P`"
	popd > /dev/null
fi

UDF_PATH="$PROJECT_HOME/asterix-udf-template"

pushd "$UDF_PATH"
	mvn clean package || { echo "UDFs build error, line $LINENO"; exit 1; }
popd

pushd "$PROJECT_HOME/asterixdb/opt/ansible/bin"
	./udf.sh -m i -d test -l testlib -p $UDF_PATH/target/asterix-udf-template-0.1-SNAPSHOT-testlib.zip \
		|| { echo "Error while installing UDFs using ansible, line $LINENO"; exit 1; } 
popd

