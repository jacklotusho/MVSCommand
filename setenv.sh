#
# Set up the mvscmd environment.
# NOTE: Before running this script, you need to have modified this file to match your z/OS system
#
#
# The following environment variables must be set up in order to install mvscmd
#
export MVSCOMMAND_ROOT=${TOOLS_ROOT}/src/MVSCommand   # Location where mvscmd installed
export CHLQ=CBC                                # High Level qualifier for C/C++ compiler datasets (e.g. ${CHLQ}.SCCNCMP is the compiler executable PDSE)
export PATH=${MVSCOMMAND_ROOT}/bin:$PATH

#
# The following environment variables are required if you want to develop and test mvscmd
#

export TESTHLQ=TSTRADM                            # High Level qualifier test datasets created under
export LEHLQ=CEE                               # High Level qualifier for LE datasets (SCEELKED, SCEELKEX, SCEERUN, SCEERUN2)
export COBOLHLQ=IGY610                         # High Level qualifier for COBOL compiler datasets (SIGYCOMP)
export PLIHLQ=IEL510                           # High Level qualifier for PL/I compiler datasets (SIBMZCMP)
export DBGHLQ=EQAE00                           # High Level qualifier for Code Coverage (optional)

export DBGLIB=${DBGHLQ}.SEQAMOD:${TESTHLQ}.CEEV2R2.CEEBINIT
