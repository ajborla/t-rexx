@echo off

:: ----------------------------------------------------------------------------
:: Script runner for t.rexx
::
:: %1 -> the test script (rexx)
:: %2 -> the application to test (rexx)
::
:: This script concatenates the files:
::
::   t1.rexx + %1.rexx + t2.rexx + %2.rexx + t3.rexx
::
:: and executes the resulting test runner file. The return code from the
:: test runner is passed back to the command-line. Valid return code values:
::
:: - 0        -> value indicates success, all tests passed
:: - positive -> value indicates failure, value equals number of failed tests
::
:: Revision History:
::
:: Date          Version     Author              Description
:: ----------    -------     ----------------    ------------------------------
:: 2015-04-03      0.0.1     Dave Nicolette      Initial implementation.
:: 2023-02-07      0.0.2     Anthony J. Borla    Prevent extraneous output.
:: 2023-02-07      0.0.3     Anthony J. Borla    Return return code.
:: 2023-02-08      0.0.4     Anthony J. Borla    Pass TAP option to runner.
:: 2023-02-09      0.0.5     Anthony J. Borla    Revised header content.
:: 2023-02-10      0.1.0     Anthony J. Borla    Add argument checks, %RC%.
:: 2023-02-10      0.2.0     Anthony J. Borla    Add file existence checks.
:: ----------------------------------------------------------------------------

:init
  set RC=1

:chkarg
  if "%2"=="" goto :argErr
  if "%1"=="" goto :argErr

:chkfile
  :: Do source and test script files exist ?
  if not exist "%2.rexx" goto :noSourceFileErr
  if not exist "%1.rexx" goto :noTestFileErr

:main
  copy/v t1.rexx+"%1.rexx"+t2.rexx+"%2.rexx"+t3.rexx t.rexx > NUL:
  rexx t.rexx TAP
  set RC=%errorlevel%
  goto :exit

:argErr
  echo Error: Incorrect arguments
  goto :exit

:noSourceFileErr
  echo Error: Missing source file - "%2.rexx"
  goto :exit

:noTestFileErr
  echo Error: Missing test script - "%1.rexx"

:exit
  exit/b %RC%

