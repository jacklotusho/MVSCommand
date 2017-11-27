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
#include <string.h>
#include "mvstempdataset.h"

int main(int argc, const char* argv[]) {
	char buffer[MAX_TEMP_DATASET_LEN+1];
	const char* prefix;
	
	if (setenv("__POSIX_TMPNAM", "NO")) {
		return 16; 
	}
	if (argc < 2) {
		prefix = "MVSTMP";
	} else {
		prefix = argv[1];
	}

	puts(temporaryMVSSequentialDataset(prefix, buffer));
	
	return 0;
}
