lastvol=`opercmd 'd u,dasd,online' | tail -1 | awk ' {print substr($0,68,6)}'`
. setcc testDDVol
echo "  LISTVTOC FORMAT,VOL=SER=${lastvol}\n" | mvscmd --pgm=iehlist --args='' --dd2=${lastvol},vol --sysin=stdin --sysprint=dummy
. unsetcc
rc=$?
if [[ ${rc} -gt 0 ]] ; then
	echo "Volume ${lastvol} could not be listed"
	exit 16
fi
