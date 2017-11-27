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
#define _XOPEN_SOURCE_EXTENDED 1

#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#include "mvstempdataset.h"

/*
 * Note: This code is not thread safe. 
 */
static int dataset_counter = 0;
char* temporaryMVSSequentialDataset(const char* prefix, char* buffer) {
	size_t prefixLen;
	int isAbsolute;
	char processQualifier[PROCESSID_LEN+1];
	char timestampQualifier[TIMESTAMP_LEN+1];
	char counterQualifier[COUNTER_LEN+1];
	pid_t pid;
	struct timeval tv;
	
	if (prefix == NULL) {
		return NULL;
	}
	prefixLen = strlen(prefix); 
	if (prefix[0] == '\'') {
		isAbsolute = 1;
		if (prefix[prefixLen-1] != '\'') {
			return NULL;
		}
		++prefix;
		prefixLen -= 2;		
	} else {
		isAbsolute = 0;
	}
	if (prefixLen > MAX_PREFIX_LEN || prefixLen <= 0) {
		return NULL;
	}
	pid = getpid();
	gettimeofday(&tv, NULL);
	
	sprintf(processQualifier,   "P%*.*d", PROCESSID_LEN-1, PROCESSID_LEN-1, pid % PROCESSID_MAX);
	sprintf(timestampQualifier, "T%*.*d", TIMESTAMP_LEN-1, TIMESTAMP_LEN-1, (tv.tv_usec) % TIMESTAMP_MAX);	
	sprintf(counterQualifier,   "C%*.*d", TIMESTAMP_LEN-1, TIMESTAMP_LEN-1, dataset_counter % COUNTER_MAX);		
	++dataset_counter;
	
	if (isAbsolute) {
		sprintf(buffer, "'%.*s.%s.%s.%s'", prefixLen, prefix, processQualifier, timestampQualifier, counterQualifier);
	} else {
		sprintf(buffer, "%.*s.%s.%s.%s", prefixLen, prefix, processQualifier, timestampQualifier, counterQualifier);
	}
	return buffer;
}	