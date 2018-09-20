#!/bin/sh
#
# Run the PL/I compiler against a simple PL/I program, writing compiler output to the console (suppressing messages with timestamps)
#

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.PLI.OBJ'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.PLI.SYSUT1'"\) dsorg\(ps\) catalog tracks space\(100,10\) >/dev/null 2>&1

(
 export STEPLIB=${PLIHLQ}.SIBMZCMP;
 . setcc pliCompiler;
 mvscmd --pgm=ibmzpli --sysprint=* --sysout=* --sysin=${TESTHLQ}.mvscmd.pli\(main\) --syslin=${TESTHLQ}.mvscmd.pli.obj\(main\) --sysut1=${TESTHLQ}.mvscmd.pli.sysut1 | awk '!/15655-/' | awk '!/0 Compiler/' ;
 . unsetcc
)

(tsocmd delete "'"${TESTHLQ}".MVSCMD.PLI.SYSUT1'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.PLI.OBJ'") >/dev/null 2>&1
