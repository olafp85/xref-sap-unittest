FUNCTION zfunc41 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

  PERFORM local_form.

ENDFUNCTION.

FORM local_form.

  PERFORM global_form.
  CALL FUNCTION 'ZFUNC42'.

ENDFORM.
