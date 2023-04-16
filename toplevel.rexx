/* Functions sharing a top-level variable:
   - Test runner: 'toplevel-check.rexx'
   - Variables:   'toplevel-variables.rexx'
   - Execute:

       ./runt toplevel-check toplevel toplevel-variables
*/
ClearTable : procedure expose table.
  lastidx = table.0
  if lastidx < 1 then ; return table.0
  drop table. ; table.0 = 0
return table.0

UpdateTable : procedure expose table.
  parse arg number
  idx = table.0 + 1
  table.idx = idx + number
  table.0 = idx
return table.0

PrintTable : procedure expose table.
  lastidx = table.0
  if lastidx < 1 then ; return '*** empty ***'
  output = "table entries:" table.0 || "0A"X
  do idx = 1 to lastidx
    output ||= "idx" idx "->" table.idx || "0A"X
  end
return STRIP(output, 'T', "0A"X)
