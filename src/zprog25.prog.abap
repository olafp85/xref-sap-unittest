REPORT zprog25 .

INTERFACE linterface1.
  CLASS-METHODS:
    method.
ENDINTERFACE.

INTERFACE linterface2.
  CLASS-METHODS:
    method.
ENDINTERFACE.

INTERFACE linterface3.
  CLASS-METHODS:
    method1,
    method2,
    method3.
ENDINTERFACE.

CLASS lclass3 DEFINITION.
  PUBLIC SECTION.
    INTERFACES linterface3.
    ALIASES alias2
      FOR linterface3~method2 .
    CLASS-METHODS:
      method.
ENDCLASS.

CLASS lclass3 IMPLEMENTATION.
  METHOD linterface3~method1.
  ENDMETHOD.
  METHOD linterface3~method2.
  ENDMETHOD.
  METHOD linterface3~method3.
  ENDMETHOD.
  METHOD method.
  ENDMETHOD.
ENDCLASS.

CLASS lclass2 DEFINITION.
  PUBLIC SECTION.
    INTERFACES linterface2.
    CLASS-METHODS:
      method,
      method1,
      method2,
      method3,
      method4,
      method5.
ENDCLASS.

CLASS lclass2 IMPLEMENTATION.
  METHOD linterface2~method.
    method5( ).
    DATA(lo_object) = NEW lclass3( ).
    lo_object->linterface3~method1( ).
    lo_object->alias2( ).
    DATA lo_interface TYPE REF TO linterface3.
    CREATE OBJECT lo_interface TYPE ('UNKNOWN_AT_DESIGNTIME').
    lo_interface->method3( ).
  ENDMETHOD.
  METHOD method.
    method3( ).
  ENDMETHOD.
  METHOD method1.
    PERFORM form.
    PERFORM form IN PROGRAM saplzfugr3.
    PERFORM form IN PROGRAM zprog3f.
  ENDMETHOD.
  METHOD method2.
    CALL FUNCTION 'ZFUNC3'.
  ENDMETHOD.
  METHOD method3.
    method( ).
    lclass3=>method( ).
    zclass3=>method( ).
  ENDMETHOD.
  METHOD method4.
    SUBMIT zprog3.
  ENDMETHOD.
  METHOD method5.
    DATA(lo_object) = NEW lclass3( ).
    lo_object->linterface3~method1( ).
    lo_object->alias2( ).

    DATA lo_interface TYPE REF TO linterface3.
    CREATE OBJECT lo_interface TYPE ('UNKNOWN_AT_DESIGNTIME').
    lo_interface->method3( ).
  ENDMETHOD.
ENDCLASS.

CLASS lclass1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES linterface1.
    CLASS-METHODS:
      method.
ENDCLASS.

CLASS lclass1 IMPLEMENTATION.
  METHOD linterface1~method.
    lclass2=>method( ).
    lclass2=>linterface2~method( ).
  ENDMETHOD.
  METHOD method.
    lclass2=>method3( ).
    lclass2=>linterface2~method( ).
  ENDMETHOD.
ENDCLASS.

FORM form.
  lclass2=>method1( ).
ENDFORM.

START-OF-SELECTION.
  lclass2=>method4( ).
