/*******************************************************************************
 * Copyright (c) 2017 IBM.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Mike Fulton - initial implentation and documentation
 *******************************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include "mvsdataset.h"
#include "mvsargs.h"

static const char* ProgramFailureMessage[] = {
	"",
	"At least %s argument must be specified.\n", 
	"At least %s arguments must be specified.\n", 
	"No more than %s arguments can be specified.\n",
	"Name %s is more than " MAX_NAME_LEN_STR " characters long.\n",
	"Name %s contains invalid characters.\n",
	"No Program name specified with program option.\n",
	"Program arguments more than " MAX_ARGS_LENGTH_STR " characters.\n",
	"No program arguments specified with argument option.\n",
	"Option not recognized.\n",
	"",
	"Out of Memory. Program ended abnormally.\n",
	"No dataset name specified for DDName %s.\n",
	"Dataset name %s is more than " MAX_DATASET_LEN_STR " characters long.\n", 
	"Invalid dataset name %s specified.\n", 
	"Unable to load program %s.\n",
	"Unable to establish environment.\n",
	"Unable to allocate all DDNames.\n",
	"Error printing dataset %s to console.\n",
	"Error calling program %s.\n",
	"Error deleting temporary dataset %s.\n",
	"Error running 64 bit module %s with mvscmd (use mvscmd64).\n",
	"Error running 31 bit module %s with mvscmd64 (use mvscmd).\n",	
	"Error dubbing module %s as process.\n",
	"Invalid dataset option %s specified.\n"
};


ProgramFailure_T allocSubstitutionStr(OptInfo_T* optInfo, const char* value, size_t length) {
	char* newValue = malloc(length+1);
	if (newValue == NULL) {
		return InternalOutOfMemory;
	}
	memcpy(newValue, value, length);
	newValue[length] = '\0';
	optInfo->substitution = newValue;

	
	return NoError;
}

static void freeSubstitutionStr(OptInfo_T* optInfo) {
	free(optInfo->substitution);
	optInfo->substitution = NULL;
}

/*
 * Overly simplistic error message processing
 */
void syntax(ProgramFailure_T reason, OptInfo_T* optInfo) {
	if (optInfo->substitution) {
		fprintf(stderr, ProgramFailureMessage[reason], optInfo->substitution);
		freeSubstitutionStr(optInfo);
	} else {
		fprintf(stderr, ProgramFailureMessage[reason]);
	}

	return;
}

void printHelp() {
	fprintf(stdout, "Syntax: %s [<args>]\n", PROG_NAME);
	fprintf(stdout, " where <args> is one or more of the following:\n");
	fprintf(stdout, " --help | -? (this help)\n");
	fprintf(stdout, " --info | -h (this help)\n");
	fprintf(stdout, " --pgm=<program-name> | -p=<program-name>  (the program to run, e.g. -p=iebcopy). Default is IEFBR14\n");
	fprintf(stdout, " --args=<program-arguments> | -a=<program-arguments> (arguments to pass to the program, e.g. -a='MARGINS(1,72)'. Default is ''\n");
	fprintf(stdout, " --verbose | -v (verbose messages). Default is off\n");
	fprintf(stdout, " --debug | -d (even more verbose messages). Default is off.\n");
	fprintf(stdout, " --<ddname>=<value> (specify a dataset, concatenated dataset, PDS member, console or dummy for the given ddname).\n");
	fprintf(stdout, "  Dataset example: --sysin=IBMUSER.TEST.OBJ: allocate the DDName SYSIN to the dataset IBMUSER.TEST.OBJ\n");
	fprintf(stdout, "  Concatenated dataset example: --syslib=CEE.SCEELKED:CEE.SCEELKEX: allocate the ddname SYSLIB to the dataset concatenation CEE.SCEELKED:CEE.SCEELKEX\n");
	fprintf(stdout, "  Console example: --sysprint=*: allocate the DDName SYSPRINT to stdout (which can then be piped to other processes).\n");
	fprintf(stdout, "  Dummy Dataset example: --sysin=dummy: allocate the DDName SYSIN to DUMMY\n");
	fprintf(stdout, " Note: DD-names and the keyword DUMMY are case-insensitive. All other options are case-sensitive\n");
	fprintf(stdout, " Example: Compare 2 PDS members 'old' and 'new' and write the output to stdout\n");
	fprintf(stdout, "  mvscmd --pgm=isrsupc --args=\"DELTAL,LINECMP\" --newdd=ibmuser.in\\(new\\) --olddd=ibmuser.in\\(old\\) --sysin=ibmuser.cmd\\(superce\\) --outdd=*\n");	
}	
	
	

static ProgramFailure_T processDebug(const char* value, Option_T* opt, OptInfo_T* optInfo) {
	optInfo->debug = 1;
	return NoError;
}

static ProgramFailure_T processHelp(const char* value, Option_T* opt, OptInfo_T* optInfo) {
	optInfo->help = 1;
	return NoError;
}

static ProgramFailure_T processPgm(const char* value, Option_T* opt, OptInfo_T* optInfo) {
	ProgramFailure_T pf;
	
	if (value[0] != ASSIGN_CHAR) {
		return NoMVSName;
	}
	++value;
	pf = validMVSName(value);
	if (pf == NoError) {
		optInfo->programName = value;
	} else {
		allocSubstitutionStr(optInfo, value, strlen(value));
	}
	return pf;
}

static ProgramFailure_T processVerbose(const char* value, Option_T* opt, OptInfo_T* optInfo) {
	optInfo->verbose = 1;
	return NoError;
}

static ProgramFailure_T processArgument(const char* value, Option_T* opt, OptInfo_T* optInfo) {
	int valLen;
	if (value[0] != ASSIGN_CHAR) {
		return NoArgSpecified;
	}
	++value;
	
	valLen = strlen(value);
	
	if (valLen > MAX_ARGS_LENGTH) {
		return ArgLengthTooLong;
	}
	
	optInfo->arguments = value;
	return NoError;
}

static const char* generalOptCmp(const char* prefix, int prefixLen, const char* optName, const char* argument) {
	int argLen;
	int optLen;
	const char* nextChar;
	if (memcmp(prefix, argument, prefixLen)) {
		return NULL;
	}
	argLen = strlen(argument);
	optLen = strlen(optName);
	if (argLen < prefixLen + optLen) {
		return NULL;
	}
	if (memcmp(&argument[prefixLen], optName, optLen)) {
		return NULL;
	}
	nextChar = &argument[prefixLen+optLen];
	if (nextChar[0] == ASSIGN_CHAR || nextChar[0] == '\0') {
		return nextChar;
	}
	
	return NULL; 
}

static const char* shortOptCmp(const char* optName, const char* argument) {
	return generalOptCmp(SHORT_OPT_PREFIX, SHORT_OPT_PREFIX_LEN, optName, argument);
}

static const char* longOptCmp(const char* optName, const char* argument) {
	return generalOptCmp(LONG_OPT_PREFIX, LONG_OPT_PREFIX_LEN, optName, argument);
}

static ProgramFailure_T processArg(const char* argument, Option_T* opts, OptInfo_T* optInfo) {
	int argLen = strlen(argument);
	const char* val;
	ProgramFailure_T rc;
	
	while (opts->shortName != NULL) {
		if (argLen > SHORT_OPT_PREFIX_LEN && (val = shortOptCmp(opts->shortName, argument)) != NULL) {
			rc = opts->fn(val, opts, optInfo);
			return rc;
		} else if (argLen > LONG_OPT_PREFIX_LEN && (val = longOptCmp(opts->longName, argument)) != NULL) {
			rc = opts->fn(val, opts, optInfo);
			return rc;
		}		
		++opts;
	}
	if (argLen > LONG_OPT_PREFIX_LEN && !memcmp(argument, LONG_OPT_PREFIX, LONG_OPT_PREFIX_LEN)) {
		rc = addDDName(&argument[LONG_OPT_PREFIX_LEN], optInfo);
	} else {
		allocSubstitutionStr(optInfo, argument, argLen);
		rc = UnrecognizedOption;
	}
	return rc;
}

ProgramFailure_T processArgs(int argc, char* argv[], OptInfo_T* optInfo) {
	Option_T options[] = {
		{ &processHelp, "?", "help" }, 
		{ &processHelp, "h", "info" }, 		
		{ &processDebug, "d", "debug" }, 
		{ &processPgm, "p", "pgm" }, 
		{ &processArgument, "a", "args" }, 
		{ &processVerbose, "v", "verbose"},
		{ NULL, NULL, NULL }
	};
	ProgramFailure_T rc;
	int i;
	
	if (argc < MIN_ARGS+1) {
		if (MIN_ARGS == 1) {
			syntax(TooFewArgsSingular, optInfo);
		} else {
			syntax(TooFewArgsPlural, optInfo);
		}
		return TooFewArgsPlural;
	}
	if (argc > MAX_ARGS) {
		syntax(TooManyArgs, optInfo);
		return TooManyArgs;
	}	
	for (i=1; i<argc; ++i) {
		rc = processArg(argv[i], options, optInfo);
		if (rc != NoError) {
			syntax(rc, optInfo);
			return rc;
		}
		if (optInfo->help) {
			syntax(IssueHelp, optInfo);
			return IssueHelp;
		}
	}
	return NoError;
}