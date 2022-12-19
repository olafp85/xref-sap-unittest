*"* use this source file for your ABAP unit test classes
CLASS ltest DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS:
      regular_method,
      method FOR TESTING.
ENDCLASS.

CLASS ltest IMPLEMENTATION.
  METHOD regular_method.
  ENDMETHOD.
  METHOD method.
    NEW zclass4( )->method2( ).
  ENDMETHOD.
ENDCLASS.
