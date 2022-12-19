*&---------------------------------------------------------------------*
*& Include          LZFUGR2F01
*&---------------------------------------------------------------------*
FORM form .
  PERFORM form1.
  CALL FUNCTION 'ZFUNC21'.
ENDFORM.

FORM form1 .
  PERFORM form.
  PERFORM form IN PROGRAM zprog3f.
  PERFORM form IN PROGRAM saplzfugr3.
ENDFORM.

FORM form2.
  CALL FUNCTION 'ZFUNC3'.
ENDFORM.

FORM form3 .
  zclass3=>method( ).
ENDFORM.

FORM form4.
  SUBMIT zprog3.
ENDFORM.
