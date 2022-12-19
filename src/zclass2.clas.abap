class ZCLASS2 definition
  public
  final
  create public .

public section.

  interfaces ZINTERFACE2 .

  class-methods METHOD .
  class-methods METHOD1 .
  class-methods METHOD2 .
  class-methods METHOD3 .
  class-methods METHOD4 .
  class-methods METHOD5 .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCLASS2 IMPLEMENTATION.


  METHOD method.
    method3( ).
  ENDMETHOD.


  METHOD method1.
    PERFORM form IN PROGRAM zprog3f.
    PERFORM form IN PROGRAM saplzfugr3.
  ENDMETHOD.


  METHOD method2.
    CALL FUNCTION 'ZFUNC3'.
  ENDMETHOD.


  METHOD method3.
    method( ).
    zclass3=>method( ).
  ENDMETHOD.


  METHOD method4.
    SUBMIT zprog3.
  ENDMETHOD.


  METHOD method5.

    DATA(lo_object) = NEW zclass3( ).
    lo_object->zinterface3~method1( ).
    lo_object->alias2( ).

    DATA lo_interface TYPE REF TO zinterface3.
    CREATE OBJECT lo_interface TYPE ('UNKNOWN_AT_DESIGNTIME').
    lo_interface->method3( ).

  ENDMETHOD.


  METHOD zinterface2~method.
    method5( ).
    DATA(lo_object) = NEW zclass3( ).
    lo_object->zinterface3~method1( ).
    lo_object->alias2( ).
    DATA lo_interface TYPE REF TO zinterface3.
    CREATE OBJECT lo_interface TYPE ('UNKNOWN_AT_DESIGNTIME').
    lo_interface->method3( ).
  ENDMETHOD.
ENDCLASS.
