#!/bin/sh
#set -x
function syntax {
	echo "Syntax: deploy.sh <directory>"
	echo " deploy the bill of materials to the specified directory"
	return 0
}

if [ $# -ne 1 ]; then
	echo "Need to provide a directory to deploy to. No parameter given."
	syntax
	exit 16
fi
if [ ! -d $1 ]; then 
	echo "Need to specify a directory to deploy to. $1 is not a directory."
	syntax
	exit 16
fi

cp -p bin/mdiff $1
rc1=$?
cp -p bin/opercmd $1
rc2=$?
cp -p bin/mvscmd $1
rc3=$?
cp -p bin/mvscmdauth $1
rc4=$?
rc=`expr $rc1 + $rc2 + $rc3 + $rc4`
exit ${rc} 
