#!/bin/sh
mvscmd -d --sysprint=* | sed "s/${TESTHLQ}.* retained for debug/xxx retained for debug/g" | sed "s/Program loaded at 0x.*/Program loaded at 0xxxx/g" | sed "s/pid:[0-9]*/pid:xxxx/g"
