REPORT zprog21f.

FORM form.
  PERFORM subform.
  PERFORM form IN PROGRAM zprog3f.
  PERFORM form IN PROGRAM saplzfugr3.
ENDFORM.

FORM mainform.
  PERFORM form.
ENDFORM.

FORM subform.

ENDFORM.
