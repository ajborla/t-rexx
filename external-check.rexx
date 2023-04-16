/* Unit Test Runner:
   - regina-specific
   - Tests functions in 'external.rexx'
   - Execute:

       ./runt --regina external-check external
*/
context('Checking the external library access functions')

/* Test Options */
numeric digits 9

/* Unit tests of functions calling external library functions */
function = 'CallPiFunc'
check('Calling external function -' function||'()',,
      function||'()',, 'to be', 3.141592654)

function = 'CallSqrtFunc'
check('Calling external function -' function||'(25)',,
      function||'(25)',, 'to be', 5.000000000)

check('Calling external function -' function||'(2)',,
      function||'(2)',, 'to be', 1.414213562)

