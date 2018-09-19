copyToDataset() {
	src=$1
        dst=$2
	iconv -fISO8859-1 -tIBM-1047 <$1 | sed 's/[ ]*$//' >/tmp/mvscmd.$1; cp -T /tmp/mvscmd.$1 "//'${2}'"
        return $?
}

#
# This will create the test datasets and copy contents in from testsrc
# used by runTests.sh
#
. ./setenv.sh
(tsocmd delete "'"${TESTHLQ}".MVSCMD.BIND.OBJ'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.IDCAMS.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.IEBCOPY.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.SUPERCE.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.IDCAMS.IN'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.IEBCOPY.IN'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.SUPERCE.IN'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.C'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.PLI'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.COBOL'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.DFSORT.MASTER'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.DFSORT.NEW'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.DFSORT.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.ADRDSU.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.TSO.CMD'") >/dev/null 2>&1
(tsocmd delete "'"${TESTHLQ}".MVSCMD.TSO.REXX'") >/dev/null 2>&1

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.BIND.OBJ'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.DLS.FILEA'"\) recfm\(v,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.DLS.FILEB'"\) recfm\(f,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.IDCAMS.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.IEBCOPY.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.SUPERCE.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.IDCAMS.IN'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.IEBCOPY.IN'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.SUPERCE.IN'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.C'"\) recfm\(v,b\) lrecl\(255\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.PLI'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.COBOL'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1

tso alloc dsn\("'"${TESTHLQ}".MVSCMD.DFSORT.MASTER'"\) recfm\(f,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.DFSORT.NEW'"\) recfm\(f,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.DFSORT.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.ADRDSU.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(ps\) dsntype\(basic\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.TSO.CMD'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1
tso alloc dsn\("'"${TESTHLQ}".MVSCMD.TSO.REXX'"\) recfm\(f,b\) lrecl\(80\) dsorg\(po\) dsntype\(library\) catalog tracks space\(10,10\) >/dev/null 2>&1

cd testsrc 

# Update the templates and cmd files to have the correct HLQ's

extension="expected"
tgtdir="../tests"
for f in *.template; do
  xx=$(basename ${f}  .template); sed -e "s/@@HLQ@@/${TESTHLQ}/g" ${f} >${tgtdir}/${xx}.${extension}
done
extension="cmd"
tgtdir="./"
for f in *.cmdtemplate; do
  xx=$(basename ${f}  .cmdtemplate); sed -e "s/@@HLQ@@/${TESTHLQ}/g" ${f} >${tgtdir}/${xx}.${extension}
done

# Copy the files from zFS into their respective datasets

cp bind.o "//'"${TESTHLQ}".MVSCMD.BIND.OBJ(BIND)'"
copyToDataset main.pli "${TESTHLQ}.MVSCMD.PLI(MAIN)"
copyToDataset main.cobol "${TESTHLQ}.MVSCMD.COBOL(MAIN)"
copyToDataset main.c "${TESTHLQ}.MVSCMD.C(MAIN)"
copyToDataset err.c "${TESTHLQ}.MVSCMD.C(ERR)"

copyToDataset iebcopy1.in "${TESTHLQ}.MVSCMD.IEBCOPY.IN(IEBCOPY1)"
copyToDataset iebcopy2.in "${TESTHLQ}.MVSCMD.IEBCOPY.IN(IEBCOPY2)"
copyToDataset iebcopy3.in "${TESTHLQ}.MVSCMD.IEBCOPY.IN(IEBCOPY3)"
copyToDataset idcams.in   "${TESTHLQ}.MVSCMD.IDCAMS.IN(IDCAMS)"
copyToDataset oldfile.in  "${TESTHLQ}.MVSCMD.SUPERCE.IN(OLDFILE)"
copyToDataset newfile.in  "${TESTHLQ}.MVSCMD.SUPERCE.IN(NEWFILE)"

copyToDataset delete.cmd    "${TESTHLQ}.MVSCMD.IDCAMS.CMD(DELETE)"
copyToDataset define.cmd    "${TESTHLQ}.MVSCMD.IDCAMS.CMD(DEFINE)"
copyToDataset superce.cmd   "${TESTHLQ}.MVSCMD.SUPERCE.CMD(SUPERCE)"
copyToDataset copysome.cmd  "${TESTHLQ}.MVSCMD.IEBCOPY.CMD(COPYSOME)"

copyToDataset dfsort.cmd     "${TESTHLQ}.MVSCMD.DFSORT.CMD"
copyToDataset dfsort.master  "${TESTHLQ}.MVSCMD.DFSORT.MASTER"
copyToDataset dfsort.new     "${TESTHLQ}.MVSCMD.DFSORT.NEW"

copyToDataset adrdsu.cmd     "${TESTHLQ}.MVSCMD.ADRDSU.CMD"
copyToDataset tsoxmit.cmd    "${TESTHLQ}.MVSCMD.TSO.CMD(XMIT)"
copyToDataset tsorcv.cmd     "${TESTHLQ}.MVSCMD.TSO.CMD(RCV)"
