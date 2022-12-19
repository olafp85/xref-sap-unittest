FUNCTION zfunc1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

  PERFORM form IN PROGRAM zprog22f.
  PERFORM form2 IN PROGRAM saplzfugr2.
  CALL FUNCTION 'ZFUNC22'.
  zclass2=>method2( ).
  SUBMIT zprog22.

ENDFUNCTION.
