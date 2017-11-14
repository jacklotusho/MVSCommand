#
# simple program to issue an operator command (make sure it is in quotes e.g. opercmd.sh 'd a')
#
if [ -z "$1" ]; then
	opercmd='d a'
else
	opercmd=$*
fi
echo "exec '${TESTHLQ}.MVSCMD.TSO.REXX(OPERCMD)' '${opercmd}'" | mvscmdauth --pgm=ikjeft01 --systsprt=* --sysprint=* --systsin=stdin
