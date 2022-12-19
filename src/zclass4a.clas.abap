class ZCLASS4A definition
  public
  inheriting from ZCLASS4
  create public .

public section.

  methods CONSTRUCTOR .

  methods METHOD3
    redefinition .
  methods METHOD4
    redefinition .
  methods METHOD5
    redefinition .
protected section.

  aliases ALIAS3
    for ZINTERFACE4B~METHOD3 .
private section.
ENDCLASS.



CLASS ZCLASS4A IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    CALL FUNCTION 'ZFUNC3'.
  ENDMETHOD.


  METHOD method3.
  ENDMETHOD.


  METHOD method4.
    method3( ).
  ENDMETHOD.


  METHOD method5.
    super->method5( ).
  ENDMETHOD.
ENDCLASS.
