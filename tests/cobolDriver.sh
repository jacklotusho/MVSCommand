#!/bin/sh
#
# Runs the COBOL compiler on a simple program. Unfortunately, the COBOL compiler needs a whole bunch of 
# work datasets in order to operate. This example writes the listing to dummy (because it can).
#

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.COBOL.OBJ'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.COBOL.SYSMDECK'"\) dsorg\(ps\) dsntype\(basic\) catalog  tracks space\(100,10\) >/dev/null 2>&1

(
 export STEPLIB=${COBOLHLQ}.V5R2M0:${LEHLQ}.SCEERUN:${LEHLQ}.SCEERUN2:$STEPLIB;
 . setcc cobolCompile;
 mvscmd -v --pgm="IGYCRCTL" --args="NONAME,NOTERM,NOLIST,NOSOURCE,NOXREF" \
  --syslin=${TESTHLQ}.mvscmd.cobol.obj\(cobol\) \
  --sysin=${TESTHLQ}.mvscmd.cobol\(main\) \
  --sysprint=dummy \
  --sysmdeck=${TESTHLQ}.mvscmd.cobol.sysmdeck \
  --sysut1=${TESTHLQ}.mvscmd.cobol.sysut1,vio \
  --sysut2=${TESTHLQ}.mvscmd.cobol.sysut2,vio \
  --sysut3=${TESTHLQ}.mvscmd.cobol.sysut3,vio \
  --sysut4=${TESTHLQ}.mvscmd.cobol.sysut4,vio \
  --sysut5=${TESTHLQ}.mvscmd.cobol.sysut5,vio \
  --sysut6=${TESTHLQ}.mvscmd.cobol.sysut6,vio \
  --sysut7=${TESTHLQ}.mvscmd.cobol.sysut7,vio \
  --sysut8=${TESTHLQ}.mvscmd.cobol.sysut8,vio \
  --sysut9=${TESTHLQ}.mvscmd.cobol.sysut9,vio \
  --sysut10=${TESTHLQ}.mvscmd.cobol.sysut10,vio \
  --sysut11=${TESTHLQ}.mvscmd.cobol.sysut11,vio \
  --sysut12=${TESTHLQ}.mvscmd.cobol.sysut12,vio \
  --sysut13=${TESTHLQ}.mvscmd.cobol.sysut13,vio \
  --sysut14=${TESTHLQ}.mvscmd.cobol.sysut14,vio \
  --sysut15=${TESTHLQ}.mvscmd.cobol.sysut15,vio ;
 . unsetcc;
)

(tsocmd delete "'"${TESTHLQ}".MVSCMD.COBOL.SYSMDECK'") >/dev/null 2>&1

(tsocmd delete "'"${TESTHLQ}".MVSCMD.COBOL.OBJ'") >/dev/null 2>&1
