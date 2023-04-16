/* Functions calling external library functions:
   - regina-specfic
   - Test runner: 'external-check.rexx'
   - Execute:

       ./runt --regina external-check external
*/
CallPiFunc : procedure
  /* Check if external library is registered */
  if RxFuncQuery('SysLoadFuncs') then do
    /* Not registered, so attempt to register, and load functions */
    call RxFuncAdd 'SysLoadFuncs', 'regutil', 'SysLoadFuncs'
    if RESULT \= 0 then ; return RxFuncErrMsg()
    call SysLoadFuncs
  end
  /* Call the external library function */
  funcResult = SysPi()
return funcResult

CallSqrtFunc : procedure
  parse arg number
  if RxFuncQuery('SysLoadFuncs') then do
    call RxFuncAdd 'SysLoadFuncs', 'regutil', 'SysLoadFuncs'
    if RESULT \= 0 then ; return RxFuncErrMsg()
    call SysLoadFuncs
  end
  funcResult = SysSqrt(number)
return funcResult
