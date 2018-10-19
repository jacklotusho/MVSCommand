#!/bin/sh
#
# Run tests that abend and verify that we can get information about the abend from mvscmd
#

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.ABEND.LOAD'"\) recfm\(u\) lrecl\(0\) blksize\(32760\) dsorg\(po\) dsntype\(library\) catalog tracks space\(1000,1000\) >/dev/null 2>&1

export ORIG_STEPLIB=${STEPLIB}
export STEPLIB=${CHLQ}.SCCNCMP:${STEPLIB}

c89 -o"//'"${TESTHLQ}".MVSCMD.ABEND.LOAD(PROTEXCP)'" ../testsrc/protexcp.c
rm protexcp.o
c89 -o"//'"${TESTHLQ}".MVSCMD.ABEND.LOAD(OPEREXCP)'" ../testsrc/operexcp.c
rm operexcp.o

(
 export STEPLIB=${TESTHLQ}.MVSCMD.ABEND.LOAD:$STEPLIB; 
. setcc ForceAbend
 mvscmd -v --pgm=PROTEXCP 2>/dev/null; protRC=$?; 
 mvscmd -v --pgm=OPEREXCP 2>/dev/null; operRC=$?
. unsetcc
 if [ ${protRC} -ne 255 ] ; then
    echo "Abending application PROTEXCP should set return code to 255. RC was: ${protRC}"
 fi
 if [ ${operRC} -ne 255 ] ; then
    echo "Abending application OPEREXCP should set return code to 255. RC was: ${operRC}"
 fi
)

(tsocmd delete "'"${TESTHLQ}".MVSCMD.ABEND.LOAD'") >/dev/null 2>&1
