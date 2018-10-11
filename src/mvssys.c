/*******************************************************************************
 * Copyright (c) 2017 IBM.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Mike Fulton - initial implementation and documentation
 *******************************************************************************/
#include <dynit.h>
#include <stdlib.h>
#include <errno.h>
#include <env.h>
#include <string.h>
#include <stdio.h>

#define _POSIX_SOURCE
#include <sys/wait.h>

#include "mvsmsgs.h"
#include "mvsdataset.h"
#include "mvssys.h"
#include "mvsargs.h"
#include "mvsutil.h"

static const char* prtAMode(AddressingMode_T amode) {
	switch(amode) {
		case AMODE24: return "AMODE24";
		case AMODE31: return "AMODE31";
		case AMODE64: return "AMODE64";
	}
	return "<unk>";
}

static void setprogInfo(OptInfo_T* optInfo, ProgramInfo_T* progInfo, unsigned long long fp, unsigned int info) {
	if ((info >> 24) != 0) {
		progInfo->APFAuthorized = 1;
	}
	progInfo->programSize = (info & 0x00FFFFFF);
	if (fp & 0x1) {
		progInfo->amode = AMODE64;
		progInfo->fp = ((fp >> 1) << 1);
	} else if (fp & 0x80000000) {
		progInfo->amode = AMODE31;
		progInfo->fp = (fp & 0x7FFFFFFF);
	} else {
		progInfo->amode = AMODE24;
		progInfo->fp = fp;
	}
	 
	if (optInfo->verbose) {
		if (progInfo->APFAuthorized) {
			printInfo(InfoAPFAuthorized); 
		}
		printInfo(InfoAddressingMode, prtAMode(progInfo->amode));
	}
	if (optInfo->debug) {	
		if (progInfo->programSize == 0) {
			printInfo(InfoProgramSizeUnknown);
		} else {
			printInfo(InfoProgramSize, (progInfo->programSize << 3));
		}
		printInfo(InfoProgramLoadAddress, progInfo->fp);
	}
}

#pragma linkage(ATTMVS, OS)
#pragma map(ATTMVS, "ATTMVS")
void ATTMVS(int* pgmNameLen, const char* pgmName, int* argsLen, const char* args, void** exitAddr, void** exitParm, int* retVal, int* retCode, int* reasonCode);

static int call24BitOr31BitProgram(OptInfo_T* optInfo, ProgramInfo_T* progInfo) {
	char pgmName[MAX_NAME_LEN+1];
	int pgmNameLen;
	int argsLen = strlen(optInfo->arguments);
	const char* args = optInfo->arguments;
	void* exitAddr = NULL;
	void* exitParm = NULL;
	int retVal = 0;
	int retCode = 0;
	int reasonCode = 0;

	strcpy(pgmName, optInfo->programName);
	uppercase(pgmName);
	pgmNameLen = strlen(pgmName);
	ATTMVS(&pgmNameLen, pgmName, &argsLen, args, &exitAddr, &exitParm, &retVal, &retCode, &reasonCode);
	if (optInfo->debug) {
		printInfo(InfoProgramAttachInfo, pgmName, retVal, retCode, reasonCode);
	}
	if (retVal == -1) {
		progInfo->rc = retCode;
	} else {
		int pid = retVal;
		int status = 0;
		if (optInfo->debug) {
			printInfo(InfoWaitingOnPID, pid);
		}
		do {
			if ((pid = waitpid(pid, &status, 0)) == -1) {
				perror("");
				printError(ErrorWaitingForPID, retVal);
			} else if (pid == 0) {
				sleep(1);
			} else {
				if (WIFEXITED(status)) {
					if (optInfo->verbose) {
						printInfo(InfoAttachExitCode, WEXITSTATUS(status), pgmName);
					}
					progInfo->rc = WEXITSTATUS(status);
				} else {
					if (WIFSIGNALED(status)) {
						printf("signal %d issued for child process %s\n", WTERMSIG(status), pgmName);
					}
					printError(ErrorChildCompletion, pgmName);
					progInfo->rc = -1;
		  	  }	
			}
		} while (pid == 0); 
	}
	return progInfo->rc;
}

static int call64BitProgram(OptInfo_T* optInfo, ProgramInfo_T* progInfo) {
	int rc = 16;
	printf("Need to build mvscmd as 64-bit to enable this.\n");
	return rc;
}

static int IAm64Bit() {
	return sizeof(void*) == 8;
}

#pragma linkage(SETDUBDF, OS)
#pragma map(SETDUBDF, "SETDUBDF")
void SETDUBDF(int* dubVal, int* retVal, int* retCode, int* reasonCode);

ProgramFailureMsg_T callProgram(OptInfo_T* optInfo, ProgramInfo_T* progInfo) {
	ProgramFailureMsg_T rc = NoError;
	if (IAm64Bit() && (progInfo->amode == AMODE64)) {
		progInfo->rc = call64BitProgram(optInfo, progInfo);
		rc = NoError;
	} else if (!IAm64Bit() && (progInfo->amode == AMODE31 || progInfo->amode == AMODE24)) {
		int dub=4; /* dub-process-defer */
		int retVal=6;
		int retCode=6;
		int reasonCode=6;
		SETDUBDF(&dub, &retVal, &retCode, &reasonCode);
		if (retVal != 0) {
			rc = ErrorDubbingProgram;
		} else {
			progInfo->rc = call24BitOr31BitProgram(optInfo, progInfo);	
			rc = NoError;
		}
	} else if (IAm64Bit() && (progInfo->amode == AMODE31)) {
		rc = ErrorRunning31BitModuleWith64BitDriver;
	} else if (!IAm64Bit() && (progInfo->amode == AMODE64)) {
		rc = ErrorRunning64BitModuleWith31BitDriver;
	}
	
	if (rc != NoError) {
		int isAPFAuth = isAPFAuthorized();
		printError(rc, optInfo->programName, PROG_NAME(isAPFAuth), PROG_NAME(isAPFAuth));
	}
	return rc;			 
}

#pragma linkage(LOAD, OS)
#pragma map(LOAD, "LOAD")
int LOAD(const char* module, unsigned int* info, unsigned long long* fp);

#pragma linkage(ISAPFAUT, OS)
#pragma map(ISAPFAUT, "ISAPFAUT")
int ISAPFAUT(void);

int isAPFAuthorized() {
	return ((ISAPFAUT() == 4) ? 0 : 1);
}

ProgramFailureMsg_T loadProgram(OptInfo_T* optInfo, ProgramInfo_T* progInfo) {
	unsigned long long fp = 0xFFFFFFFFFFFFFFFFLL;
	char program[MAX_NAME_LEN+1];
	int rc;
	unsigned int info = 0xFFFFFFFF;	

	uppercaseAndPad(program, optInfo->programName, MAX_NAME_LEN);
	if (optInfo->verbose) {
		printInfo(InfoLoadProgram, program);
	}
	rc = LOAD(program, &info, &fp);
	if (rc == 0) {
		int isAPFAuth = isAPFAuthorized();
		setprogInfo(optInfo, progInfo, fp, info);	
		if (isAPFAuth) {
			if (progInfo->APFAuthorized) {
				; /* all good */
			} else {
				printError(ErrorCallingUnauthorizedFromAuthorized, optInfo->programName, PROG_NAME(1), PROG_NAME(0));
				return ErrorCallingUnauthorizedFromAuthorized;
			}
		} else {
			if (!progInfo->APFAuthorized) {
				; /* all good */
			} else {
				printError(ErrorCallingAuthorizedFromUnauthorized, optInfo->programName, PROG_NAME(0), PROG_NAME(1));
				return ErrorCallingAuthorizedFromUnauthorized;
			}			
		}
		return NoError;
	} else {
		if (optInfo->verbose) {
			printInfo(InfoLoadProgramDetails, program, rc);
		}
		printError(UnableToFetchProgram, program);
		
		return UnableToFetchProgram;
	}
}
