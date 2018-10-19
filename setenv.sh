#!/bin/sh
#set -x
#
# Set up the mvscmd environment.
# NOTE: Before running this script, you need to have modified this file to match your z/OS system
# Alternately, you can set the environment variables explicitly 
#
# The following environment variables must be set up in order to install mvscmd
#
export MVSCOMMAND_ROOT="${MVSCOMMAND_ROOT:=${HOME}/MVSCommand}" 	# Location where mvscmd installed
export CHLQ="${CHLQ:=CBC}"				# High Level qualifier for C/C++ compiler datasets (e.g. ${CHLQ}.SCCNCMP is the compiler executable PDSE)
export PATH=${MVSCOMMAND_ROOT}/bin:$PATH

#
# The following environment variables are only required if you want to develop and test mvscmd
#
export TESTHLQ="${TESTHLQ:=TSTRADM}"                    # High Level qualifier test datasets created under
export LEHLQ="${LEHLQ:=CEE}"                            # High Level qualifier for LE datasets (SCEELKED, SCEELKEX, SCEERUN, SCEERUN2)
export COBOLHLQ="${COBOLHLQ:=IGY610}"                   # High Level qualifier for COBOL compiler datasets (SIGYCOMP)
export PLIHLQ="${PLIHLQ:=IEL520}"                       # High Level qualifier for PL/I compiler datasets (SIBMZCMP)
export DBGHLQ="${DBGHLQ:=EQAE00}"                       # High Level qualifier for Code Coverage (optional)
export RDTDDS="${RDTDDS:=RDTD.RDT.V1R0M6.LOAD}"		# Dataset with RDTD in it
export TMPVOL="${TMPVOL:=USER10}"                       # Temporary volume to write VSAM datasets to

export DBGLIB=${DBGHLQ}.SEQAMOD:${TESTHLQ}.CEEV2R2.CEEBINIT

