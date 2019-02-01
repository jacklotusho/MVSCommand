#!/bin/sh
#
# It is important that the C code be built with XPLink. If it is not, then if you try to system() call to an XPLink built program (such as the C compiler), LE will abend.
# It is important that OSCALL(UPSTACK) be used because the assembler code that is called to do a LOAD expects traditional upstack OS Linkage
# GONUM and OFFSET make it easier to debug with no real downside
# LANGLVL(EXTENDED) is required because of the z-specific extensions that are utilized
# Listings aren't required
#
# It is important that mvscmdauth have the +a attribute (APF authorization) so that it runs authorized.
# Some environments set the _BPX_SHAREAS environment variable to 'YES' or 'REUSE'. mvscmd/mvscmdauth will not function correctly it runs in a 
# shared environment and therefore we need to explicitly mark it as such by setting the -s attribute (no sharing)
#
mydir() {
        cmdlinename=`basename $0`
	if [ "${cmdlinename}" = "$0" ]; then
		# Must be in the PATH
		mydir=`type -a mvsutils`
	else
            	# Must have been explicitly specified on the command line
		mydir=`dirname $0`
	fi
	echo "${mydir}"
}

DEFAULT_MODE="OPT"

if [ -z "${1}" ]; then
	mode=${DEFAULT_MODE};
else
    	mode=${1};
fi
if [ ${mode} = 'DEBUG' ] ; then
	echo 'Build Debug Version'
	export ASM_OPTS=''
	export CC_OPTS='-g -DDEBUG'
	export LINK_OPTS='-g'
else
    	echo 'Build Default Version'
	export ASM_OPTS=''
	export CC_OPTS='-O2'
	export LINK_OPTS='-O2'
fi

. ./setenv.sh

mydir=`mydir`

buildfile="${mydir}/src/buildinfo.c"
echo "/* Generated File. Do Not Edit */" >"${buildfile}"
stamp=`date -c '+%Y/%m/%d %T %Z'`
echo "char* buildInfo = \"${stamp}\";" >>"${buildfile}"

export STEPLIB=${CHLQ}.SCCNCMP
cd bin
rm -f mvscmd mvscmdauth *.o *.lst *.dbg
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvstmp.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvstempdataset.c
c89 -o mvstmp ${LINK_OPTS} -Wl,xplink mvstmp.o mvstempdataset.o

c89 -c ${ASM_OPTS} -Wa,list ../src/mvsload.s  >mvsload.lst 2>/dev/null
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvsutil.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvsargs.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvsmsgs.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvsdataset.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvssys.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/mvscmd.c
c89 -c ${CC_OPTS} -Wc,xplink\(OSCALL\(UPSTACK\)\),csect,gonum,offset,langlvl\(extended\),list\(./\) ../src/buildinfo.c
c89 -o mvscmd ${LINK_OPTS} -Wl,xplink,ac=1 mvscmd.o mvsargs.o mvsdataset.o mvssys.o mvsutil.o mvsload.o mvsmsgs.o mvstempdataset.o buildinfo.o
rm -rf mvscmdauth
cp mvscmd mvscmdauth
extattr +a mvscmdauth
extattr -s mvscmd
extattr -s mvscmdauth
