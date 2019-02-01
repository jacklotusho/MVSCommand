#!/bin/sh
#
# Set up the mvscmd environment.
# NOTE: Before running this script, you need to have modified this file to match your z/OS system
#
# The following environment variables must be set up in order to install mvscmd
#

if [ -z ${MVSCOMMAND_ROOT} ]; then
	export MVSCOMMAND_ROOT=${TOOLS_ROOT}/src/MVSCommand   # Location where mvscmd installed
fi
export CHLQ=CBC                                # High Level qualifier for C/C++ compiler datasets (e.g. ${CHLQ}.SCCNCMP is the compiler executable PDSE)
export PATH=${MVSCOMMAND_ROOT}/bin:$PATH

#
# The following environment variables are only required if you want to develop and test mvscmd
#

export TESTHLQ=TSTRADM                            # High Level qualifier test datasets created under
export LEHLQ=CEE                               # High Level qualifier for LE datasets (SCEELKED, SCEELKEX, SCEERUN, SCEERUN2)
export COBOLHLQ=IGY610                         # High Level qualifier for COBOL compiler datasets (SIGYCOMP)
export PLIHLQ=IEL520                           # High Level qualifier for PL/I compiler datasets (SIBMZCMP)
export DBGHLQ=EQAE00                           # High Level qualifier for Code Coverage (optional)
export TEST_SKIP_LIST="adrdssu errorScenarios forceFail" # adrdssu requires a PTF still in development, errorScenarios requires RDTD (need a better test) and forceFail requires dev build

export DBGLIB=${DBGHLQ}.SEQAMOD:${TESTHLQ}.CEEV2R2.CEEBINIT
export TMPVOL=USER10                           # Temporary volume to write VSAM datasets to
