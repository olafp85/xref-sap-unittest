class ZCLASS4B definition
  public
  inheriting from ZCLASS4A
  final
  create public .

public section.

  methods ZINTERFACE4A~METHOD1
    redefinition .
protected section.
private section.

  aliases ALIAS4
    for ZINTERFACE4B~METHOD4 .
ENDCLASS.



CLASS ZCLASS4B IMPLEMENTATION.


  METHOD zinterface4a~method1.
    alias2( ).
    alias3( ).
    alias4( ).
    zinterface4b~method5( ).
  ENDMETHOD.
ENDCLASS.
