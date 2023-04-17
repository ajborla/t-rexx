/* Rexx unit test framework
   1. Concatenate these files:

         toplevel (Optional Rexx file containing shared variables)
         t1.rexx
         test-script
         t2.rexx
         rexx-file-to-test
         t3.rexx

      to create file:

         t.rexx

   2. Execute t.rexx

   This file is t1.rexx
*/

/* functions for the test framework */

init:
  parse upper arg outputType
  checkNumber = 0
  count = 0
  passed = 0
  failed = 0
  contextdesc = ''
  checkresult. = ''
  divider = '----------------------------------------'
  spacer = ' '
  EOL = "0A"X
return

context : procedure expose contextdesc
  parse arg desc
  contextdesc = desc
return ''

check:
  parse arg description, procedureCall, variableName, operation, expectedValue

  checkNumber = checkNumber + 1

  returnedValue = ''
  if right(procedureCall,1) = ')' then
    interpret 'returnedValue = 'procedureCall
  else do
    if procedureCall \= '' then ; interpret 'call 'procedureCall
  end

  assertion = expect(returnedValue, variableName, operation, expectedValue)

  count = count + 1
  checkresult.0 = count

  select
    when outputType == 'TAP' then do
      checkresult.count = assertion count '-' description
    end
    when outputType == 'JSON' then do
      parse value STRIP(assertion) with testResult ':' .
      /* Ensure conforming field values */
      testStatus = 'pass' ; if testResult \= 'PASSED' then ; testStatus = 'fail'
      conjunction = 'and' ; if testStatus \= 'pass' then ; conjunction = 'but'
      if expectedValue == '' then ; expectedValue = "''"
      if returnedValue == '' then ; returnedValue = "''"
      /* Remove procedure name from description if it exists there */
      delidx = POS(procedureCall, description)
      if delidx > 0 then ; description = STRIP(DELSTR(description, delidx))
      /* Package test results as JSON */
      checkresult.count = ,
        MakeJSONTestResult( ,
          description,,
          testStatus,,
          'Expected' expectedValue conjunction 'got' returnedValue,,
          '',,
          procedureCall op expectedValue,,
          1,,
          EOL)
    end
    otherwise
      checkresult.count = right(count,2) || '. ' || assertion || ' - Test: ' || description
  end

return ''

expect:
  parse arg actual, variableName, op, expected

  if variableName <> '' then
    actualValue = value(variableName)
  else do
    actualValue = actual
  end

  select
    when op == 'to be' | op == '=' then
      return report(actualValue, op, expected, actualValue == expected)
    when op == 'not to be' | op == '^=' | op == '<>' then
      return report(actualValue, op, expected, actualValue \== expected)
    when op == 'larger than' | op == '>' then
      return report(actualValue, op, expected, actualValue > expected)
    when op == 'larger than or equal to' | op == '>=' then
      return report(actualValue, op, expected, actualValue >= expected)
    when op == 'less than' | op == '<' then
      return report(actualValue, op, expected, actualValue < expected)
    when op == 'less than or equal to' | op == '<=' then
      return report(actualValue, op, expected, actualValue <= expected)
    otherwise do
      say 'operand 'op' unknown. Known operands are:'
      say '  to be (=), '
      say '  not to be (^= or <>), '
      say '  larger than (>),'
      say '  larger than or equal to (>=), '
      say '  less than (<) and'
      say '  less than or equal to (<=)'
      say '.......exiting'
      exit
    end
  end
return

report : procedure expose passed failed outputType
  parse arg actual, op, expected, res
  lineout = ''
  select
    when res == 0 then do
      failed = failed + 1
      if outputType == 'TAP' then
        lineout = 'not ok'
      else do
        lineout = '*** FAILED: Expected "' || expected || '" but got "' || actual || '"'
      end
    end
    when res == 1 then do
      passed = passed + 1
      if outputType == 'TAP' then
        lineout = 'ok'
      else do
        lineout = '    PASSED: Expected "' || expected || '" and got "' || actual || '"'
      end
    end
  end
return lineout

counts : procedure expose text. count passed failed
  text.0 = 3
  text.1 = right(count,2) ' checks were executed'
  text.2 = right(passed,2) ' checks passed'
  text.3 = right(failed,2) ' checks failed'
return text

MakeJSONTestResult : procedure
  parse arg name, status, message, output, test_code, task_id, eol
  json = ,
    '    {' || eol || ,
    '      "name": "' || name || '",' || eol || ,
    '      "status": "' || status || '",' || eol || ,
    '      "message": "' || message || '",' || eol || ,
    '      "output": "' || output || '",' || eol || ,
    '      "test_code": "' || test_code || '",' || eol || ,
    '      "task_id":' task_id || eol || ,
    '    }'
return json

