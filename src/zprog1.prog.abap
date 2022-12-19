REPORT zprog1.

INCLUDE zincl1.

START-OF-SELECTION.
  PERFORM form IN PROGRAM zprog24f.
  PERFORM form4 IN PROGRAM saplzfugr2.
  CALL FUNCTION 'ZFUNC24'.
  zclass2=>method4( ).
  SUBMIT zprog24.
