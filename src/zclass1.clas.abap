class ZCLASS1 definition
  public
  final
  create public .

public section.

  interfaces ZINTERFACE1 .

  class-methods METHOD .
protected section.
private section.
ENDCLASS.



CLASS ZCLASS1 IMPLEMENTATION.


  METHOD method.
    PERFORM form IN PROGRAM zprog23f.
    PERFORM form3 IN PROGRAM saplzfugr2.
    CALL FUNCTION 'ZFUNC23'.
    zclass2=>method3( ).
    SUBMIT zprog23.
    zclass2=>method( ).
    zclass2=>zinterface2~method( ).
  ENDMETHOD.


  METHOD zinterface1~method.
    zclass2=>method( ).
    zclass2=>zinterface2~method( ).
  ENDMETHOD.
ENDCLASS.
