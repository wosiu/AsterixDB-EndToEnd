#!/bin/bash

set -e

if [ "$PROJECT_HOME" == "" ]
then
	pushd `dirname $0` > /dev/null
	PROJECT_HOME=`pwd -P`
	popd > /dev/null
fi

source "$PROJECT_HOME/scripts/commons.sh"
if isAsterixRunning
then
	echo "Asterix is running, stop previous instance..";
	exit 1;
fi

# ensure can ssh
ssh localhost -C 'echo "Can ssh"' || { 
		echo "Cannot ssh localhost without password, run:"
		echo "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
		echo "if you know what you're doing"
		exit 1
	}


# installing ansible inside virtualenv as I don't have sudo on student		
echo "============== CREATE ENV ============"	
INSTALL_ENV="$PROJECT_HOME/env"
if [ ! -d "$INSTALL_ENV" ]
then
	PYTHON2_PATH=`which python2`
	virtualenv --python="$PYTHON2_PATH" $INSTALL_ENV || { echo "Error $LINENO"; exit 1; }
else
	echo "Using existing env, if want to recreate: rm -r $INSTALL_ENV"
fi

pushd "$PROJECT_HOME/scripts"
	echo "=================== ENTER ENV ==============="
	source $INSTALL_ENV/bin/activate || { echo "Error $LINENO"; exit 1; }

	echo "============== INSTALLING ANSIBLE ==========="
	./install_ansible.sh || { echo "Error $LINENO"; exit 1; }
	echo "============== INSTALLING ASTERIX ==========="
	./install_asterix.sh || { echo "Error $LINENO"; exit 1; }
	echo "=============== INSTALLING UDFS ============="
	./install_udfs.sh || { echo "Error $LINENO"; exit 1; }
	echo "============== STARTING ASTERIX ============="
	./start_asterix.sh || { echo "Error $LINENO"; exit 1; }
	
	# virtual env is required only when using ansible
	deactivate

	echo "============= INITIALIZING DATA ============="
	./init_data.sh || { echo "Error $LINENO"; exit 1; }
popd

echo "Asterix is running, run script/stop_asterix.sh after you're done"
