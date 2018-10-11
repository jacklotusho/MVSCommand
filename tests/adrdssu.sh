#!/bin/sh
# Run ADRDSSU to take a set of datasets and write them to an archive.
# Run ADRDSSU again, but getting input from stdin instead of a dataset
# Pros of ADRDSSU over IKJEFT01 and IEBCOPY: easy to take a very large number of datasets and archive them
# Cons: requires APF authorization to run the command because of this power
#
#set -x
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.ADRDSSU.DARV1'"\) recfm\(u\) lrecl\(0\) blksize\(32760\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10000\)

(
 . setcc adrdssuCreateViaDataset;
 mvscmdauth -v --pgm=ADRDSSU --args='SDUMP=049' --archive=${TESTHLQ}.mvscmd.adrdssu.darv1,old --sysin=${TESTHLQ}.mvscmd.adrdssu.cmd --sysprint=* | awk '!/1PAGE 0001|ADR109I|ADR006I|ADR801I|ADR006I|ADR013I|ADR012I/'
 . unsetcc

)

(tsocmd delete "'"${TESTHLQ}".MVSCMD.ADRDSSU.DARV1'") 

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.ADRDSSU.DARV2'"\) recfm\(u\) lrecl\(0\) blksize\(32760\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10000\)

(
  . setcc adrdssuCreateViaStdin;
  echo " DUMP OUTDD(ARCHIVE) -\n    DS(INCL(${TESTHLQ}.MVSCMD.IEBCOPY.**))" | 
    mvscmdauth --pgm=ADRDSSU --archive=${TESTHLQ}.mvscmd.adrdssu.darv2,old --sysin=stdin --sysprint=stdout |
    awk '!/1PAGE 0001|ADR109I|ADR006I|ADR801I|ADR006I|ADR013I|ADR012I/'
 . unsetcc
)

(tsocmd delete "'"${TESTHLQ}".MVSCMD.ADRDSSU.DARV2'")
