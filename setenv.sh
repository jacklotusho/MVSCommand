#
# Set up the mvscmd environment.
# NOTE: Before running this script, you need to have modified this file to match your z/OS system
# AND you need to have added ${AUTHHLQ}.${AUTHLD} to your LNKLST 
#

#
# The following environment variables must be set up in order to install mvscmd
#
export MVSCOMMAND_ROOT=/u/ibmuser/MVSCommand   # Location where mvscmd installed
export CHLQ=CBC                                # High Level qualifier for C/C++ compiler datasets (e.g. ${CHLQ}.SCCNCMP is the compiler executable PDSE)
export AUTHHLQ=IBMUSER                         # High Level qualifier where authorized version of MVSCMD written
export AUTHLD=MVSCMD.LOAD                      # ${AUTHHLQ}.${AUTHLD} needs to be pre-allocated and added to your LNKLST -BEFORE- installing mvscmd
export PATH=${MVSCOMMAND_ROOT}/bin:$PATH

tsocmd "listds '${AUTHHLQ}.${AUTHLD}'" >/dev/null 2>&1
rc=$?
if [[ ${rc} -gt 0 ]] ; then
	echo "Dataset ${AUTHHLQ}.${AUTHLD} must be pre-allocated to a PDSE (program object library)"
	return
fi
tsocmd "listds '${AUTHHLQ}.${AUTHRX}'" >/dev/null 2>&1
rc=$?

llaInfo=`opercmd 'd lla' | grep "${AUTHHLQ}.${AUTHLD}"`
rc=$?
if [[ ${rc} -gt 0 ]] ; then
	echo "Dataset ${AUTHHLQ}.${AUTHLD} is not in the Library Lookaside (LLA). Please add this dataset to the LLA"
	return
else
	words=`echo ${llaInfo} | wc -w`
	if [[ ${words} -ne 4 ]] ; then 
		echo "Dataset ${AUTHHLQ}.${AUTHLD} is in the library Lookaside (LLA) but is NOT APF authorized."
		vol=`tsocmd listds "'${AUTHHLQ}.${AUTHLD}'" | tail -1n` 2>/dev/null
		opercmd "setprog apf,add,dsn=${AUTHHLQ}.${AUTHLD},vol=${vol}" >/dev/null 2>&1		
		echo "Dataset ${AUTHHLQ}.${AUTHLD} has been APF authorized. You should add this dataset to your APF list as part of your IPL configuration"
	fi
fi

#
# The following environment variables are required if you want to develop and test mvscmd
#

export TESTHLQ=IBMUSER                         # High Level qualifier test datasets created under
export LEHLQ=CEE                               # High Level qualifier for LE datasets (SCEELKED, SCEELKEX, SCEERUN, SCEERUN2)
export COBOLHLQ=IGY610                         # High Level qualifier for COBOL compiler datasets (SIGYCOMP)
export PLIHLQ=IEL510                           # High Level qualifier for PL/I compiler datasets (SIBMZCMP)
export DBGHLQ=EQAE00                           # High Level qualifier for Code Coverage (optional)

export DBGLIB=${DBGHLQ}.SEQAMOD:${TESTHLQ}.CEEV2R2.CEEBINIT
