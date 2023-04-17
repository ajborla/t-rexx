/* Unit Test Runner:
   - Application: 'toplevel.rexx'
   - Variables:   'toplevel-variables.rexx'
   - Execute:

       ./runt toplevel-check toplevel toplevel-variables
*/
context('Checking the toplevel access functions')

/* Code under test shares the following variable(s):
  table.
*/

/* Unit tests */
function = 'ClearTable'
check('Table is empty - direct stem access' function||'()',,
      function||'()', 'table.0', 'to be', 0)

check('Table is empty - function return value' function||'()',,
      function||'()',, 'to be', 0)

function = 'PrintTable'
check('Table is empty - return value' function||'()',,
      function||'()',, 'to be', '*** empty ***')

function = 'UpdateTable'
check('Table has 1 entry - return value' function||'(100)',,
      function||'(100)',, 'to be', 1)

check('Table has 1 entry - direct stem access' function||'(100)',,
      function||'(100)', 'table.0', 'to be', 1)

check('Table Entry 1 value - direct stem access' function||'(100)',,
      function||'(100)', 'table.1', 'to be', 100 + 1)

/* Add a further 5 entries to the shared table */
do 5 ; call UpdateTable 100 ; end

check('Table has 6 entries - direct stem access' function||'(100)',,
      function||'(100)', 'table.0', 'to be', 6)

check('Table Entry 6 value - direct stem access' function||'(100)',,
      function||'(100)', 'table.6', 'to be', 100 + 6)

expval = ,
  'table entries: 6' || "0A"X || ,
  'idx 1 -> 101' || "0A"X || ,
  'idx 2 -> 102' || "0A"X || ,
  'idx 3 -> 103' || "0A"X || ,
  'idx 4 -> 104' || "0A"X || ,
  'idx 5 -> 105' || "0A"X || ,
  'idx 6 -> 106'

retval = PrintTable()

function = 'PrintTable'
check('PrintTable output' 'table entries: 6 ...',,
      function||'()', 'retval', 'to be', expval)

