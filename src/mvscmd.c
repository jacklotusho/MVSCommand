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
#include <stdio.h>
#include <limits.h>
#include <ctype.h>
#include <dynit.h>
#include <stdlib.h>
#include <errno.h>
#include <env.h>
#include <string.h>

#define _POSIX_SOURCE
#include <sys/wait.h>

#include "mvsmsgs.h"
#include "mvsdataset.h"
#include "mvssys.h"
#include "mvsargs.h"

static ProgramFailureMsg_T establishEnvironment() {
	ProgramFailureMsg_T rc;
	if (setenv("__POSIX_TMPNAM", "NO", 1) || FORCE(FAIL_SetEnvPOSIXTmpNam)) {
		rc = UnableToEstablishEnvironment;
	} else if (setenv("__POSIX_SYSTEM", "NO", 1) || FORCE(FAIL_SetEnvPOSIXSystem)) {
		rc = UnableToEstablishEnvironment;
	} else {
		rc = NoError;
	}
	if (rc != NoError) {
		printError(ErrorEstablishingEnvironment);	
	}
	return rc;
}

extern char* buildInfo;

int main(int argc, char* argv[]) {
	OptInfo_T optInfo = { DEFAULT_MVSCMD, "", NULL, 0, 0, 0, 0 };
	ProgramInfo_T progInfo = { 0, 0, 0, 0, 0 };

	ProgramFailureMsg_T rc;

	rc = establishEnvironment();
	if (rc != NoError) {
		return 16;
	}
	
	rc = processArgs(argc, argv, &optInfo);
	if (rc == IssueHelp) {
		printHelp(PROG_NAME(isAPFAuthorized()));
	}	

	if (optInfo.buildInfo) {
		printInfo(InfoBuild, buildInfo);
	}	
	if (rc != NoError) {
		return 8;
	}
	
	rc = establishDDNames(&optInfo);
	if (rc != NoError) {
		return 8;
	}
	rc = loadProgram(&optInfo, &progInfo);
	if (rc != NoError) {
		return rc;
	}
	
	rc = callProgram(&optInfo, &progInfo);
	if (rc != NoError) {
		return 16;
	}	
	rc = freeDDNames(&optInfo);
	if (rc != NoError) {
		return 8;
	}	
	rc = printToConsole(&optInfo);
	if (rc != NoError) {
		return 8;
	}
	rc = removeConsoleFiles(&optInfo);
	if (rc != NoError) {
		return 8;
	}
	
	if (rc == NoError) {
		return progInfo.rc;
	} else {
		return rc;
	}	
}
	
