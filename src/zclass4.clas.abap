class ZCLASS4 definition
  public
  create public .

public section.

  interfaces ZINTERFACE4A .
  interfaces ZINTERFACE4B .

  aliases ALIAS1
    for ZINTERFACE4A~METHOD1 .
  aliases ALIAS2
    for ZINTERFACE4B~METHOD2 .

  methods METHOD1 .
  methods METHOD2 .
  methods METHOD3 .
  methods METHOD4 .
  methods METHOD5 .
protected section.
private section.
ENDCLASS.



CLASS ZCLASS4 IMPLEMENTATION.


  METHOD method1.
    lclass=>method( ).
  ENDMETHOD.


  METHOD METHOD2.
  ENDMETHOD.


  METHOD METHOD3.
  ENDMETHOD.


  METHOD METHOD4.
  ENDMETHOD.


  METHOD METHOD5.
  ENDMETHOD.


  method ZINTERFACE4A~METHOD1.
  endmethod.


  method ZINTERFACE4B~METHOD2.
  endmethod.


  method ZINTERFACE4B~METHOD3.
  endmethod.


  method ZINTERFACE4B~METHOD4.
  endmethod.
ENDCLASS.
