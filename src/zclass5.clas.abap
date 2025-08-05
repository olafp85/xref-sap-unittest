class ZCLASS5 definition
  public
  final
  create public .

public section.

  class-methods METHOD1 .
  class-methods METHOD2 .
  class-methods METHOD3
    importing
      !PARAMETER type ref to ZCDSVIEW4 .
  class-methods METHOD4 .
  class-methods METHOD5 .
protected section.
private section.
ENDCLASS.



CLASS ZCLASS5 IMPLEMENTATION.


  METHOD method1.
    SELECT COUNT( * ) FROM zcdsview4.
  ENDMETHOD.


  METHOD method2.
    DATA data1 TYPE ztab5.
    SELECT COUNT( * ) FROM zcdsfunc3.
  ENDMETHOD.


  METHOD method3.
  ENDMETHOD.


  METHOD method4.
    SELECT COUNT( * ) FROM zview7.
  ENDMETHOD.


  METHOD method5.
    SELECT COUNT( * ) FROM zcdsview7.
  ENDMETHOD.
ENDCLASS.
