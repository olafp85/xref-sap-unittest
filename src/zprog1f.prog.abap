REPORT zprog1f.

FORM form.
  PERFORM form IN PROGRAM zprog21f.
  PERFORM form1 IN PROGRAM saplzfugr2.
  CALL FUNCTION 'ZFUNC21'.
  zclass2=>method1( ).
  SUBMIT zprog21.
ENDFORM.
