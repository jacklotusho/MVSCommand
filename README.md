## Synopsis

This project enables z/OS developers to access MVS commands like IEBCOPY and IDCAMS from the Unix System Services environment.
+[![Join the chat at https://gitter.im/MVSCommand/Lobby](https://badges.gitter.im/MVSCommand/Lobby.svg)](https://gitter.im/MVSCommand/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
 +

## Pre-built binaries

If you want to just use the tools and not build them yourself, you can [![download](https://api.bintray.com/packages/fultonm/MVSUtil/MVSCommand/images/download.svg) ](https://bintray.com/fultonm/MVSUtil/MVSCommand/_latestVersion) a binary pax file.

## Code Example

Here is an example of **mvscmd** being used to copy dataset IBMUSER.TEST.C to IBMUSER.TEST.COPY, writing output from IEBCOPY to the screen

mvscmd --pgm=IEBCOPY --sysprint=* --sysin=dummy --sysut1=ibmuser.test.c --sysut2=ibmuser.test.copy

## Motivation

I am not a big fan of JCL, even though I have worked on z/OS forever. 
I also try to use Unix System Services as much as possible to develop software. 
Unfortunately, if you want to run an MVS command, such as IDCAMS to work with VSAM datasets, you need to create JCL, submit JCL, 
poll until the JCL completes, then interpret the results from USS. This is annoying.
This made me wonder why we couldn't just run the MVS program from USS directly. 

## Installation
Note: You no longer need to use a PDSE for the mvscmdauth. The build has been changed to set the APF-authorized bit on for the mvscmdauth executable in the HFS
My thanks to Zhang Hong (Tony) Chen for this improvement. 

Note that _git pull_ will put the files into the zFS file system in ASCII. You can either iconv the files to EBCDIC if you don't want to push any changes, or set the following environment variables to work in ASCII
```
export _BPXK_AUTOCVT=ON
export _CEE_RUNOPTS='FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)'
export _TAG_REDIR_ERR=txt
export _TAG_REDIR_IN=txt
export _TAG_REDIR_OUT=txt
export GIT_SHELL=${TOOLS_ROOT}/bin/bash
export GIT_EXEC_PATH=${TOOLS_ROOT}/libexec/git-core
export GIT_TEMPLATE_DIR=${TOOLS_ROOT}/share/git-core/templates
```

To install:
- copy the files to z/OS Unix System Services directory. For this example, we assume it is /u/ibmuser/MVSCommand
- cd to the directory (/u/ibmuser/MVSCommand)
- edit setenv.sh to point to the various MVS programs that will be tested, and to specify where your code was copied to. 
- edit build.sh if required to point to your C compiler and assembler, then run the script to build the program.
- run build.sh: build.sh
- The assemble, compile and link should be 'clean' and will produce a file called 'mvscmd' and an authorized version called 'mvscmdauth'

## API Reference

To get started reading the code, begin in mvscmd.c, which has 'main' and drives all the functions in the other files.

## Tests

To run the tests:
- cd to the directory (e.g. /u/ibmuser/MVSCommand)
- crtTests.sh
- runTests.sh

This will write results to the screen as it runs the testcases in the tests sub-directory. You will see failures
in the forceFail tests if you didn't build with DEBUG.

## Contributors

Mike Fulton (IBM Canada) is the sole contributor at this point. I am happy to change this :)

The code still needs work. Error messages can (always) be improved and there are missing features people may need. (for example, 64-bit utilities)
If anyone wants to contribute, please reach out to fultonm@ca.ibm.com (Mike Fulton)

## License

The code uses the Eclipse Public License 1.0 ( https://opensource.org/licenses/eclipse-1.0.php )


