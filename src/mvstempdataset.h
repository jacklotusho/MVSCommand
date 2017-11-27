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

#ifndef _MVSTEMPDATASET_
	#define _MVSTEMPDATASET_ 1
	
	#define PROCESSID_LEN            8
	#define TIMESTAMP_LEN            8
	#define COUNTER_LEN              8
	#define MAX_TEMP_DATASET_LEN    44
	#define MAX_PREFIX_LEN          (MAX_TEMP_DATASET_LEN - PROCESSID_LEN - 1 - TIMESTAMP_LEN - 1 - COUNTER_LEN - 1) 	
	
	#define PROCESSID_MAX 10000000
	#define TIMESTAMP_MAX 10000000
	#define COUNTER_MAX   10000000
	
	char* temporaryMVSSequentialDataset(const char* prefix, char* buffer);
#endif