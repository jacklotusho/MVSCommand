#!/bin/sh
#
# test that help comes out using -? -h --help
#
. setcc HelpAbbrev
mvscmdauth -h
. unsetcc 
. setcc HelpLong
mvscmdauth --help
. unsetcc
. setcc infoAbbrev
mvscmd -?
. unsetcc
. setcc infoLong
mvscmd --info
. unsetcc
