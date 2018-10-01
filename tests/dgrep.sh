#!/bin/sh
#
# simple program that searches all the PDS members for a string, e.g. dgrep IEFPROC sys1.proclib
#
if [ "$#" -ne 2 ]; then
	echo "Syntax: dgrep <string> <datasetpattern>"
	exit 16
fi
str=$1;
datasetpattern=$2;

datasets=`echo " LISTCAT -\n ENTRIES("${datasetpattern}")\n" | mvscmdauth --pgm=idcams --sysprint=* --sysin=stdin | awk '/0NONVSAM/ { print $3 }' `
for dataset in ${datasets}; do
	testid=`echo ${dataset} | tr '.' '_'`
	. setcc "search"${testid};
	echo "SRCHFOR '"${str}"'\n" | mvscmd --pgm=isrsupc --args='SRCHCMP,ANYC,IDPRFX,NOSUMS,LONGLN,NOPRTCC' --newdd=${dataset} --outdd=* --sysin=stdin | awk '!/  ISRSUPC/';
	. unsetcc
done
