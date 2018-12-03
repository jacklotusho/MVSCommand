#!/bin/sh
. ./setenv.sh 
./crtTests.sh
cd tests
rm -f *.actual
#set -x

if [ -z $1 ] ; then
	testEnv.sh >testEnv.actual 2>&1
	diff -w testEnv.actual testEnv.expected >/dev/null
	if [[ $? -ne 0 ]]; then
		echo 'Basic environment test for mvscmd and mvscmdauth failed. Tests not run'
		exit $?
	fi
	tests=*.sh
else
	tests=${1}.sh
fi
if [ -z "${TEST_SKIP_LIST}" ]; then  
	export TEST_SKIP_LIST=""
fi

maxrc=0	
for test in ${tests}; do
	name="${test%.*}"
	if test "${TEST_SKIP_LIST#*$name}" != "$TEST_SKIP_LIST"; then
		echo "Skip ${test}"
	else
		echo ${test}
		if [ -e ${name}.parm ]; then
			parms=`cat ${name}.parm`
		else
			parms=''
		fi
		${test} ${parms} >${name}.actual 2>&1
		mdiff -Z ${name}.expected ${name}.actual
		rc=$?
		if [ ${rc} -gt ${maxrc} ]; then
			maxrc=${rc}
		fi
	fi
done
exit ${maxrc}
