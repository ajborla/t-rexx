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
:: ----------------------------------------------------------------------------

copy/v t1.rexx+"%1.rexx"+t2.rexx+"%2.rexx"+t3.rexx t.rexx > NUL:
rexx t.rexx TAP
exit/b %errorlevel%

