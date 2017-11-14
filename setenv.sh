#
# To be called from createTests and runTests to set up the environment
# Modify this file to match your z/OS system
#

#
# The following environment variables must be set up in order to install mvscmd
#
export MVSCOMMAND_ROOT=/u/ibmuser/MVSCommand   # Location where mvscmd installed
export CHLQ=CBC                                # High Level qualifier for C/C++ compiler datasets (e.g. ${CHLQ}.SCCNCMP is the compiler executable PDSE)
export AUTHHLQ=IBMUSER                         # High Level qualifier where authorized version of MVSCMD written
export AUTHSFX=MVSCMD.LOAD                     # Dataset suffix where authorized version of MVSCMD written
                                               # ${AUTHHLQ}.${AUTHSFX} needs to already be APF authorized and must already be allocated
                                               # The dataset must also be a program object library, otherwise known as a PDSE
export PATH=${MVSCOMMAND_ROOT}/bin:$PATH
export STEPLIB=${AUTHHLQ}.${AUTHSFX}:$STEPLIB  # If this library is already in the LLA, you do not need to STEPLIB this dataset

#
# The following environment variables are required if you want to develop and test mvscmd
#

export TESTHLQ=IBMUSER                         # High Level qualifier test datasets created under
export LEHLQ=CEE                               # High Level qualifier for LE datasets (SCEELKED, SCEELKEX, SCEERUN, SCEERUN2)
export COBOLHLQ=IGY610                         # High Level qualifier for COBOL compiler datasets (SIGYCOMP)
export PLIHLQ=IEL510                           # High Level qualifier for PL/I compiler datasets (SIBMZCMP)
export DBGHLQ=EQAE00                           # High Level qualifier for Code Coverage (optional)

export DBGLIB=${DBGHLQ}.SEQAMOD:${TESTHLQ}.CEEV2R2.CEEBINIT
