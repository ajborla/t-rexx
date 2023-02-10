# t.rexx

Unit testing framework for Rexx.

The test framework comprises three Rexx files: t1, t2, and, t3, each containing a piece of the test framework.

Concatenating these files with a Rexx test script, and the Rexx file to be tested, results in the creation of a single Rexx program, ```t.rexx```, the unit test suite.

The order of concatenation is:

1. t1.rexx -> variables used by the test framework
1. the file containing the test script
1. t2.rexx -> boilerplate code that displays the results of the tests
1. the file containing the code to be tested
1. t3.rexx -> test framework functions

## Running tests with bash

The bash script ```runt``` performs the concatenation and executes the resulting file. For example, to run the 'calc' example provided in this repo, run the script as follows:

```shell
./runt calc-check calc
```

If TAP-compliant output is required, invoke as follows:

```shell
./runt --tap-output calc-check calc
```

Test run return code is available to launch script, so may also use in automated scenarios:

```shell
./runt --tap-output "${tester}" "${cut}" 2>&1 >/dev/null \
    && { ... do success stuff ... } \
    || { ... do failure stuff ... }
```

Note that the assembled Rexx test runner (default name: `t.rexx`) is automatically deleted at the end of each test run, but may be kept for debugging purposes by using the `--keep` option.

## Running tests with Windows batch

The batch file ```runt.bat``` performs the concatenation and executes the resulting file. For example, to run the 'calc' example provided in this repo, run the script as follows:

```shell
runt calc-check calc
```

If TAP-compliant output is required, invoke as follows:

```shell
runt --tap-output calc-check calc
```

Test run return code is available to launch script, so may also use in automated scenarios:

```shell
runt --tap-output "%TESTER%" "%CUT%" 2> NUL: > NUL:
if not errorlevel 0 goto :failure
goto :success
```

Note that the assembled Rexx test runner (default name: `t.rexx`) is automatically deleted at the end of each test run, but may be kept for debugging purposes by using the `--keep` option.

## Writing your own test

There are two Rexx functions to call in your test script:
* context()
* check()

Syntax:
  * context('description') is the test suite description
  * check() is the check procedure to check the function return code or variables set/changed in a procedure.
    - input to check()
      - arg1: description of the test
      - arg2: procedure call, including arguments
      - arg3: variable name to check, if any
      - arg4: an operand like =, <>, >, <, >= or <=
      - arg5: expected value
  * Samples:
```shell
check( 'Adding 5 and 2', "calc(5,  '+', 2)",, 'to be', 7)
check( 'Dividing 15 by 3 = 5', "calcWithoutAnyReturn 15, '/', 3", 'calcResult', '=', 5)
```

## Running tests with JCL

On a z/OS system, concatenate the files and run the resulting Rexx program using any mechanism you prefer. For example, you could use ```IKJEFT01``` to run a test script.

Sample JCL below, originally sourced from [Microfocus Visual COBOL](https://www.microfocus.com/documentation/visual-cobol/):

```
//REXXTSO JOB 'IKJEFT01 REXX',CLASS=A,MSGCLASS=A
//*
//CREATE    EXEC  PGM=IEBGENER
//SYSIN     DD  DUMMY
//SYSPRINT  DD  SYSOUT=A,HOLD=YES
//SYSUT2    DD  DSN=&TEMPREX(REXTSO),DISP=(,PASS),
// SPACE=(CYL,(1,1,1)),UNIT=3390,
// DCB=(LRECL=80,RECFM=FB,DSORG=PO)
//SYSUT1    DD  DSN=[t1 file],DISP=SHR
            DD  DSN=[test script file],DISP=SHR
            DD  DSN=[t2 file],DISP=SHR
            DD  DSN=[file to be tested],DISP=SHR
            DD  DSN=[t3 file],DISP=SHR
//RUN       EXEC PGM=IKJEFT01,PARM='REXTSO'
//SYSEXEC   DD DSN=&TEMPREX,DISP=(SHR,PASS)
//SYSTSPRT  DD SYSOUT=A,HOLD=YES
//SYSTSIN   DD DUMMY
//
```
## Motivation
In late 2022, I accepted the challenge of implementing a Rexx track on the learn-to-program platform, [Exercism](https://exercism.org/). A core component of this endeavour is a suitable unit test framework.

I initally opted for a custom solution because requirements were for a lightweight framework with minimal functionality. However, I chanced upon [Lars Hansen's](https://github.com/oakmount66/t-rexx) fork of _t-rexx_, and thought I could modify that project to meet requirements.

## Acknowledgements
I would like to acknowldege [Dave Nicolette](https://github.com/neopragma/t-rexx) for initiating the _t-rexx_ project, and the sterling work [Lars Hansen](https://github.com/oakmount66/t-rexx) has done in extending the framework's functionality by adding  mocking support.

## Change history
* 0.0.1 initial version by Dave Nicolette
* 0.0.2 (not tested on z/OS nor Windows)
  - Variable initialization moved to init-procedure in t3.rexx
  - t1, t2 and t3 renamed to .rexx to trigger indent, coloring etc in VScode
  - check() function expanded to handle both calls to functions and procedures
  - check() function expanded to compare named varables instead of only return values
  - check() function expanded also to handle =, <, >, <>, ^= >= and <=
  - call to expect() function moved from test script to check() function in t3.rexx
  - a lot more samples added.
* 0.0.3 (not tested on z/OS nor Windows)
  - mock() function added
* 0.0.4 (not tested on z/OS nor Windows)
  - mock() function renamed to localmock()
  - globalmock() added
  - result from program with mocks collected and printed at the end of the run
* 0.0.5 (not tested on z/OS)
  - mocking functionality removed
* 0.0.6 (not tested on z/OS)
  - test runner caller receives return code indicating test run success / failure
  - test results now alternatively reported in TAP-compliant format
  - `runt.bat` and `runt` launch scripts expanded and hardened
