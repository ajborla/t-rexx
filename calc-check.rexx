/* ****************************************************************************
 * test script to demonstrate the rexx unit test framework
 *
 * Syntax:
 *   context('description') is the test suite description
 *
 *   check() is the check procedure to check return codes from a function or
 *   variables set or changed in a procedure.
 *   input to check()
 *      arg1: Description of the test
 *      arg2: procedure call incl. arguments, optionally omit if passing arg3
 *      arg3: variable name to check, required if arg2 omitted
 *      arg4: operand like =, <>, >, <, >= <=, 'to be', or 'not to be'
 *      arg5: expected value
 *************************************************************************** */

context('Checking',
        'the calc function',
        'and the calcWithoutAnyReturn procedure')

check('Check if variable "op" is set to "to be"', 'calc(3, "+", 4)', 'op',,
      'to be', 'to be')
check('Check if variable "op" is set to "="', 'calc(3, "+", 4)', 'op',,
      '=', '=')
check('Adding 5 and 2', 'calc(5,  "+", 2)',, 'to be', 7)
check('Subtracting 3 from 10', 'calc(10, "-", 3)',, 'to be', 7)
check('Multiplying 15 and 2 - must fail',  'calc(15, "*", 2)',, 'to be', 31)
check('Dividing 3 into 15 not to be 13', 'calc(15, "/", 3)',, 'not to be', 13)
check('Dividing 3 into 15 ^= 13', 'calc(15, "/", 3)',, '^=', 13)
check('Dividing 3 into 15 <> 13', 'calc(15, "/", 3)',, '<>', 13)
check('Dividing 3 into 15 not to be 5 - must fail', 'calc(15, "/", 3)',,,
      'not to be', 5)
check('Dividing 3 into 15 ^= 5 - must fail', 'calc(15, "/", 3)',, '^=', 5)

check('Dividing 15 by 3 <= 6 - must fail', 'calcWithoutAnyReturn 15, "/", 3','calcResult', '<=', 4)
check('Dividing 15 by 3 = 5', 'calcWithoutAnyReturn 15, "/", 3', 'calcResult', '=', 5)
check('Dividing 15 by 3 != 4',,
      'calcWithoutAnyReturn 15, "/", 3',,
      'calcResult',,
      '>=',,
      4)

