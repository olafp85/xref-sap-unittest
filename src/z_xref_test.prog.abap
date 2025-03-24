*--------------------------------------------------------------------*
CLASS ltcl_unit DEFINITION
*--------------------------------------------------------------------*
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS:
      constructor.

  PROTECTED SECTION.
    DATA:
      mo_main TYPE REF TO lcl_task_analyze,
      mo_unit TYPE REF TO lcl_unit.

    METHODS:
      set_unit IMPORTING string TYPE string.

  PRIVATE SECTION.
    METHODS:
      get_component FOR TESTING,
      get_components FOR TESTING,
      get_include FOR TESTING,
      get_package FOR TESTING,
      get_program FOR TESTING,
      get_segment FOR TESTING,
      get_segments FOR TESTING,
      init FOR TESTING,
      is_standard_sap FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_unit IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD constructor.
    "De SETUP-methode moet in elke subklasse opnieuw gedefinieerd worden, de CONSTRUCTOR niet
    mo_main = NEW #( ).
  ENDMETHOD.

  METHOD set_unit.
    IF string CS '|'.
      mo_unit = lcl_units=>get( type = segment( val = string  sep = '|'  index = 1 )
                                name = segment( val = string  sep = '|'  index = 2 )
                                comp = COND #( WHEN count( val = string  sub = '|' ) = 2 THEN segment( val = string  sep = '|'  index = 3 ) ) ).
    ELSE.
      mo_unit = lcl_units=>get_by_full_name( string ).
    ENDIF.
  ENDMETHOD.

  METHOD get_component.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_bound( lo_component ).
    lo_component = mo_unit->get_component( 'UNKNOWN' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).

    "Interface
    set_unit( `INTF|ZINTERFACE1` ).
    lo_component = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_bound( lo_component ).
    lo_component = mo_unit->get_component( 'UNKNOWN' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_bound( lo_component ).
    lo_component = mo_unit->get_component( 'UNKNOWN' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).

    "Programma
    set_unit( `PROG|ZPROG1F` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_bound( lo_component ).
    lo_component = mo_unit->get_component( 'UNKNOWN' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).
  ENDMETHOD.

  METHOD get_components.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\TY:ZCLASS1\IN:ZINTERFACE1\ME:METHOD` )
                             ( `\TY:ZCLASS1\ME:METHOD` ) ) ).
    "negeer testklassen
    set_unit( `CLAS|ZCLASS4` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\TY:ZCLASS4\IN:ZINTERFACE4A\ME:METHOD1` )
                             ( `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD2` )
                             ( `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD3` )
                             ( `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD4` )
                             ( `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD5` )
                             ( `\TY:ZCLASS4\ME:METHOD1` )
                             ( `\TY:ZCLASS4\ME:METHOD2` )
                             ( `\TY:ZCLASS4\ME:METHOD3` )
                             ( `\TY:ZCLASS4\ME:METHOD4` )
                             ( `\TY:ZCLASS4\ME:METHOD5` )
                             ( `\TY:ZCLASS4\TY:LCLASS\ME:METHOD` ) ) ).

    "Interface
    set_unit( `INTF|ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\TY:ZINTERFACE1\ME:METHOD` ) ) ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_components( ) ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\FG:ZFUGR1\FO:FORM` )
                             ( `\FG:ZFUGR1\FU:ZFUNC1` ) ) ).

    "Programma
    set_unit( `PROG|ZPROG21F` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\PR:ZPROG21F\FO:FORM` )
                             ( `\PR:ZPROG21F\FO:MAINFORM` )
                             ( `\PR:ZPROG21F\FO:SUBFORM` ) ) ).
    set_unit( `PROG|BCALV_GRID_DEMO` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE stringtab( FOR c IN mo_unit->get_components( ) ( c->id ) )
      exp = VALUE stringtab( ( `\PR:BCALV_GRID_DEMO\FO:EXIT_PROGRAM` )
                             ( `\PR:BCALV_GRID_DEMO\MO:PBO` )
                             ( `\PR:BCALV_GRID_DEMO\MX:PAI` ) ) ).
  ENDMETHOD.

  METHOD get_include.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_include( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_include( )
      exp = 'ZCLASS1=======================CM001' ).

    "Interface
    set_unit( `INTF|ZINTERFACE1` ).
    lo_component = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_include( ) ).
    cl_abap_unit_assert=>assert_initial( lo_component->get_include( ) ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_include( )
      exp = 'LZFUGR1U01' ).
    cl_abap_unit_assert=>assert_initial( lo_component ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_include( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_include( )
      exp = 'LZFUGR1F01' ).

    "Programma
    set_unit( `PROG|ZPROG1F` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_include( )
      exp = 'ZPROG1F' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_include( )
      exp = 'ZPROG1F' ).
  ENDMETHOD.

  METHOD get_package.
    set_unit( `PROG|BCALV_GRID_DEMO` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_package( )
      exp = 'SLIS' ).

    set_unit( `PROG|ZPROG1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_package( )
      exp = '$XREF_UNITTEST' ).

    set_unit( `FUGR|DEMO_RFC` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_package( )
      exp = 'SABAPDEMOS' ).
  ENDMETHOD.

  METHOD get_program.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_program( )
      exp = 'ZCLASS1=======================CP' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_program( )
      exp = 'ZCLASS1=======================CP' ).

    "Interface
    set_unit( `INTF|ZINTERFACE1` ).
    lo_component = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_program( )
      exp = 'ZINTERFACE1===================CP' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_program( )
      exp = 'ZINTERFACE1===================CP' ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_program( )
      exp = 'SAPLZFUGR1' ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_program( )
      exp = 'SAPLZFUGR1' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_program( )
      exp = 'SAPLZFUGR1' ).

    "Programma
    set_unit( `PROG|ZPROG1F` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_program( )
      exp = 'ZPROG1F' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_program( )
      exp = 'ZPROG1F' ).
  ENDMETHOD.

  METHOD get_segment.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_segment( cl_abap_compiler=>tag_type )
      exp = 'ZCLASS1' ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_segment( 1 )
      exp = 'ZFUGR1' ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_unit->get_segment( 2 )
      exp = 'ZFUNC1' ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_segment( 3 ) ).
    cl_abap_unit_assert=>assert_initial( mo_unit->get_segment( 'XX' ) ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_segment( 2 )
      exp = 'FORM' ).

    "Programma
    set_unit( `PROG|ZPROG25` ).
    lo_component = mo_unit->get_component( '\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_component->get_segment( 'IN' )
      exp = 'LINTERFACE2' ).
  ENDMETHOD.

  METHOD get_segments.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE name2stringvalue_table( FOR s IN lo_component->get_segments( ) ( name = s-name  value = s-value ) )
      exp = VALUE name2stringvalue_table( ( name = `TY` value = `ZCLASS1` )
                                          ( name = `ME` value = `METHOD` ) ) ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE name2stringvalue_table( FOR s IN mo_unit->get_segments( ) ( name = s-name  value = s-value ) )
      exp = VALUE name2stringvalue_table( ( name = `FG` value = `ZFUGR1` )
                                          ( name = `FU` value = `ZFUNC1` ) ) ).

    "Programma
    set_unit( `PROG|ZPROG25` ).
    lo_component = mo_unit->get_component( '\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD' ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE name2stringvalue_table( FOR s IN lo_component->get_segments( ) ( name = s-name  value = s-value ) )
      exp = VALUE name2stringvalue_table( ( name = `PR` value = `ZPROG25` )
                                          ( name = `TY` value = `LCLASS2` )
                                          ( name = `IN` value = `LINTERFACE2` )
                                          ( name = `ME` value = `METHOD` ) ) ).
  ENDMETHOD.

  METHOD init.
    "Klasse
    set_unit( `CLAS|ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `CLAS` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZCLASS1' ).

    set_unit( `\TY:ZCLASS1` ).  "GET_BY_FULL_NAME
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZCLASS1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `CLAS` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZCLASS1' ).

    "Methode
    DATA(lo_component) = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->id           exp = `\TY:ZCLASS1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->full_name    exp = `\TY:ZCLASS1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->type         exp = `CLAS` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->get_name( )  exp = 'ZCLASS1' ).

    set_unit( `\TY:ZCLASS1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZCLASS1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZCLASS1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `CLAS` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZCLASS1' ).

    "Interface
    set_unit( `INTF|ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `INTF` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZINTERFACE1' ).

    set_unit( `\TY:ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `INTF` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZINTERFACE1' ).

    "Methode
    lo_component = mo_unit->get_component( 'METHOD' ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->id           exp = `\TY:ZINTERFACE1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->full_name    exp = `\TY:ZINTERFACE1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->type         exp = `INTF` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->get_name( )  exp = 'ZINTERFACE1' ).

    set_unit( `\TY:ZINTERFACE1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZINTERFACE1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZINTERFACE1\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `INTF` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZINTERFACE1' ).

    "Functiegroep
    set_unit( `FUGR|ZFUGR1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\FG:ZFUGR1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\PR:SAPLZFUGR1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `FUGR` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZFUGR1' ).

    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->id           exp = `\FG:ZFUGR1\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->full_name    exp = `\PR:SAPLZFUGR1\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->type         exp = `FUGR` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->get_name( )  exp = 'ZFUGR1' ).

    set_unit( `\FG:ZFUGR1\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\FG:ZFUGR1\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\PR:SAPLZFUGR1\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `FUGR` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZFUGR1' ).

    "Functie
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\FG:ZFUGR1\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `FUNC` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZFUNC1' ).

    set_unit( `FUGR|ZFUGR1|ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\FG:ZFUGR1\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `FUNC` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZFUNC1' ).

    set_unit( `FUGR|ZFUGR1` ).
    lo_component = mo_unit->get_component( 'ZFUNC1' ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->id           exp = `\FG:ZFUGR1\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->full_name    exp = `\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->type         exp = `FUNC` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->get_name( )  exp = 'ZFUNC1' ).

    set_unit( `\FG:ZFUGR1\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\FG:ZFUGR1\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\FU:ZFUNC1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `FUNC` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZFUNC1' ).

    "Programma
    set_unit( `PROG|ZPROG1F` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\PR:ZPROG1F` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\PR:ZPROG1F` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `PROG` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZPROG1F' ).

    lo_component = mo_unit->get_component( 'FORM' ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->id           exp = `\PR:ZPROG1F\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->full_name    exp = `\PR:ZPROG1F\FO:FORM` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->type         exp = `PROG` ).
    cl_abap_unit_assert=>assert_equals( act = lo_component->get_name( )  exp = 'ZPROG1F' ).

    "CDS
    set_unit( `DDLS|ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:zCdsView1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `DDLS` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZCDSVIEW1' ).

    set_unit( `\TY:ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:zCdsView1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `DDLS` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZCDSVIEW1' ).

    "Tabel
    set_unit( `TABL|ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `TABL` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZTAB1' ).

    set_unit( `\TY:ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:ZTAB1` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `TABL` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'ZTAB1' ).

    "Methode GET_BY_FULL_NAME doet geen controle op het bestaan van het object
    set_unit( `\TY:UNKNOWN` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->id           exp = `\TY:UNKNOWN` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->full_name    exp = `\TY:UNKNOWN` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->type         exp = `` ).
    cl_abap_unit_assert=>assert_equals( act = mo_unit->get_name( )  exp = 'UNKNOWN' ).
  ENDMETHOD.

  METHOD is_standard_sap.
    set_unit( `PROG|RSUSR000` ).
    cl_abap_unit_assert=>assert_true( mo_unit->is_standard_sap( ) ).

    set_unit( `PROG|ZPROG1` ).
    cl_abap_unit_assert=>assert_false( mo_unit->is_standard_sap( ) ).

    set_unit( `FUGR|ZFUGR1` ).
    cl_abap_unit_assert=>assert_false( mo_unit->is_standard_sap( ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_units DEFINITION
*--------------------------------------------------------------------*
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      get FOR TESTING,
      get_by_full_name FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_units IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD get.
    set_unit( `UNKNOWN|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).

    "Package
    set_unit( `DEVC|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `DEVC|SLIS` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Klasse
    set_unit( `CLAS|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `CLAS|ZCLASS1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
    set_unit( `CLAS|ZCLASS1|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `CLAS|ZCLASS1|METHOD` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
    set_unit( `CLAS|ZCLASS1|ZINTERFACE1~METHOD` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Interface
    set_unit( `INTF|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `INTF|ZINTERFACE1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
    set_unit( `INTF|ZINTERFACE1|METHOD` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Functie
    set_unit( `FUNC|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `FUNC|ZFUNC1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Functiegroep
    set_unit( `FUGR|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `FUGR|ZFUGR1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Programma
    set_unit( `PROG|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `PROG|ZPROG1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "CDS
    set_unit( `DDLS|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `DDLS|ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
    set_unit( `DDLS|ZCDSFUNC1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Tabel
    set_unit( `TABL|UNKNOWN` ).
    cl_abap_unit_assert=>assert_initial( mo_unit ).
    set_unit( `TABL|ZTAB1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
  ENDMETHOD.

  METHOD get_by_full_name.
    set_unit( `\TY:ZCLASS1` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).

    "Geen controle op het bestaan van het object
    set_unit( `\TY:UNKNOWN` ).
    cl_abap_unit_assert=>assert_bound( mo_unit ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_ddls_func DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_cds FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_method FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_ddls_func IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_cds.
    set_unit( `DDLS|ZCDSFUNC1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView5`  target = `\TY:zCdsFunc1` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `DDLS|ZCDSFUNC3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS5\ME:METHOD2`  target = `\TY:zCdsFunc3` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `DDLS|ZCDSFUNC2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG44`  target = `\TY:zCdsFunc2` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `DDLS|ZCDSFUNC1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsFunc1`  target = `\TY:ZAMDP\ME:METHOD1` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_ddls_view DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_cds FOR TESTING,
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_table FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_ddls_view IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_cds.
    set_unit( `DDLS|ZCDSVIEW3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView2`  target = `\TY:zCdsView3` ) ) ).

    "zCdsView6 niet omdat _DefaultAddresses weliswaar voorkomt in de velden maar niet in de select of via associations
    set_unit( `DDLS|I_BUSINESSPARTNERDEFAULTADDR` ).
    cl_abap_unit_assert=>assert_initial(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls ).
  ENDMETHOD.

  METHOD called_by_form.
    set_unit( `DDLS|ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR5\FO:FORM`   target = `\TY:zCdsView1` )
                            ( source = `\PR:ZPROG4F\FO:FORM`  target = `\TY:zCdsView1` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `DDLS|ZCDSVIEW2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR5\FU:ZFUNC5`  target = `\TY:zCdsView2` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `DDLS|ZCDSVIEW4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG42\TY:LCLASS\ME:METHOD`                target = `\TY:zCdsView4` )
                            ( source = `\PR:ZPROG43\TY:LCLASS\IN:LINTERFACE\ME:METHOD`  target = `\TY:zCdsView4` )
                            ( source = `\TY:ZCLASS5\ME:METHOD1`                         target = `\TY:zCdsView4` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `DDLS|ZCDSVIEW5` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG41`  target = `\TY:zCdsView5` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `DDLS|ZCDSVIEW2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView2`  target = `\TY:zCdsView3` ) ) ).

    "Standaard SAP ziet ook I_BusinessPartnerDefaultAddr en I_Address als onderdeel vanwege de gebruikte velden
    set_unit( `DDLS|ZCDSVIEW6` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          include_sap_objects = abap_true
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView6`  target = `\TY:BUT001` )
                            ( source = `\TY:zCdsView6`  target = `\TY:I_BusinessPartner` )
                            ( source = `\TY:zCdsView6`  target = `\TY:I_Username` ) ) ).
  ENDMETHOD.

  METHOD calls_table.
    set_unit( `DDLS|ZCDSVIEW1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView1`  target = `\TY:ZTAB1` )
                            ( source = `\TY:zCdsView1`  target = `\TY:ZTAB2` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_fugr DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by FOR TESTING,
      calls FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_fugr IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by.
    set_unit( `FUGR|ZFUGR2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls(
                            ( source = `\FG:ZFUGR1\FO:FORM`     target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\FG:ZFUGR1\FO:FORM`     target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\FG:ZFUGR1\FU:ZFUNC1`   target = `\FG:ZFUGR2\FO:FORM2` )
                            ( source = `\FG:ZFUGR1\FU:ZFUNC1`   target = `\FG:ZFUGR2\FU:ZFUNC22` )
                            ( source = `\FG:ZFUGR2\FO:FORM`     target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\FG:ZFUGR2\FO:FORM`     target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`    target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21`  target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\PR:ZPROG1`             target = `\FG:ZFUGR2\FO:FORM4` )
                            ( source = `\PR:ZPROG1`             target = `\FG:ZFUGR2\FU:ZFUNC24` )
                            ( source = `\PR:ZPROG1F\FO:FORM`    target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\PR:ZPROG1F\FO:FORM`    target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\FG:ZFUGR2\FO:FORM3` )
                            ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\FG:ZFUGR2\FU:ZFUNC23` ) ) ).
  ENDMETHOD.

  METHOD calls.
    set_unit( `FUGR|ZFUGR2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FO:FORM`    target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\FG:ZFUGR2\FO:FORM`    target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`   target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`   target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`   target = `\PR:ZPROG3F\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FO:FORM2`   target = `\FG:ZFUGR3\FU:ZFUNC3` )
                            ( source = `\FG:ZFUGR2\FO:FORM3`   target = `\TY:ZCLASS3\ME:METHOD` )
                            ( source = `\FG:ZFUGR2\FO:FORM4`   target = `\PR:ZPROG3` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21` target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21` target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21` target = `\PR:ZPROG3F\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC22` target = `\FG:ZFUGR3\FU:ZFUNC3` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC23` target = `\TY:ZCLASS3\ME:METHOD` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC24` target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_fugr_form DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_fugr_form IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `FUGR|ZFUGR2|FORM1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FO:FORM`   target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\FG:ZFUGR2\FO:FORM`   target = `\FG:ZFUGR2\FO:FORM1` )
                            ( source = `\PR:ZPROG1F\FO:FORM`  target = `\FG:ZFUGR2\FO:FORM1` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `FUGR|ZFUGR2|FORM2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FU:ZFUNC1`  target = `\FG:ZFUGR2\FO:FORM2` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `FUGR|ZFUGR2|FORM3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\FG:ZFUGR2\FO:FORM3` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `FUGR|ZFUGR2|FORM4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1`  target = `\FG:ZFUGR2\FO:FORM4` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `FUGR|ZFUGR5|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR5\FO:FORM`  target = `\TY:zCdsView1` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `FUGR|ZFUGR2|FORM1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FO:FORM1`  target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FO:FORM1`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `FUGR|ZFUGR2|FORM2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FO:FORM2`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `FUGR|ZFUGR2|FORM3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FO:FORM3`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `FUGR|ZFUGR2|FORM4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FO:FORM4`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_func DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_func IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `FUNC|ZFUNC21` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FO:FORM`   target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\FG:ZFUGR2\FO:FORM`   target = `\FG:ZFUGR2\FU:ZFUNC21` )
                            ( source = `\PR:ZPROG1F\FO:FORM`  target = `\FG:ZFUGR2\FU:ZFUNC21` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `FUNC|ZFUNC22` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FU:ZFUNC1`  target = `\FG:ZFUGR2\FU:ZFUNC22` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `FUNC|ZFUNC23` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\FG:ZFUGR2\FU:ZFUNC23` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `FUNC|ZFUNC24` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1`  target = `\FG:ZFUGR2\FU:ZFUNC24` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `FUNC|ZFUNC5` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR5\FU:ZFUNC5`  target = `\TY:zCdsView2` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `FUNC|ZFUNC21` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FU:ZFUNC21`  target = `\FG:ZFUGR2\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\FG:ZFUGR2\FU:ZFUNC21`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `FUNC|ZFUNC22` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FU:ZFUNC22`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `FUNC|ZFUNC23` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FU:ZFUNC23`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `FUNC|ZFUNC24` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR2\FU:ZFUNC24`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_meth DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_meth IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `CLAS|ZCLASS2|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FO:FORM`   target = `\TY:ZCLASS2\ME:METHOD1` )
                            ( source = `\PR:ZPROG1F\FO:FORM`  target = `\TY:ZCLASS2\ME:METHOD1` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `CLAS|ZCLASS2|METHOD2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FU:ZFUNC1`  target = `\TY:ZCLASS2\ME:METHOD2` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `CLAS|ZCLASS2|METHOD3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\TY:ZCLASS2\ME:METHOD3` )
                            ( source = `\TY:ZCLASS2\ME:METHOD`  target = `\TY:ZCLASS2\ME:METHOD3` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `CLAS|ZCLASS2|METHOD4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1` target = `\TY:ZCLASS2\ME:METHOD4` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `CLAS|ZCLASS5|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS5\ME:METHOD1`  target = `\TY:zCdsView4` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `CLAS|ZCLASS2|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS2\ME:METHOD1`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\TY:ZCLASS2\ME:METHOD1`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `CLAS|ZCLASS2|METHOD2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS2\ME:METHOD2`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `CLAS|ZCLASS2|METHOD3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS2\ME:METHOD3`  target = `\TY:ZCLASS2\ME:METHOD` )
                            ( source = `\TY:ZCLASS2\ME:METHOD3`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `CLAS|ZCLASS2|METHOD4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS2\ME:METHOD4`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_meth_amdp DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_cds FOR TESTING,
      calls_table FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_meth_amdp IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_cds.
    set_unit( `CLAS|ZAMDP|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsFunc1`  target = `\TY:ZAMDP\ME:METHOD1` ) ) ).
  ENDMETHOD.

  METHOD calls_table.
    set_unit( `CLAS|ZAMDP|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZAMDP\ME:METHOD1`  target = `\TY:ZTAB5` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `PROG|ZPROG21` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FO:FORM`   target = `\PR:ZPROG21` )
                            ( source = `\PR:ZPROG1F\FO:FORM`  target = `\PR:ZPROG21` )
                            ( source = `\PR:ZPROG21`          target = `\PR:ZPROG21\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `PROG|ZPROG22` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FU:ZFUNC1`  target = `\PR:ZPROG22` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `PROG|ZPROG23` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\PR:ZPROG23` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `PROG|ZPROG24` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1`  target = `\PR:ZPROG24` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `PROG|ZPROG41` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG41`  target = `\TY:zCdsView5` )       "select
                            ( source = `\PR:ZPROG41`  target = `\TY:zCdsView6` ) ) ).  "data definitie

    set_unit( `PROG|ZPROG44` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG44`  target = `\TY:zCdsFunc2` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `PROG|ZPROG21` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG21`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\PR:ZPROG21`  target = `\PR:ZPROG21\FO:FORM` )
                            ( source = `\PR:ZPROG21`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `PROG|ZPROG22` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG22`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `PROG|ZPROG23` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG23`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `PROG|ZPROG24` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG24`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog_form DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog_form IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `PROG|ZPROG21F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FO:FORM`        target = `\PR:ZPROG21F\FO:FORM` )
                            ( source = `\PR:ZPROG1F\FO:FORM`       target = `\PR:ZPROG21F\FO:FORM` )
                            ( source = `\PR:ZPROG21F\FO:MAINFORM`  target = `\PR:ZPROG21F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD called_by_function.
    set_unit( `PROG|ZPROG22F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR1\FU:ZFUNC1`  target = `\PR:ZPROG22F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `PROG|ZPROG23F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\ME:METHOD`  target = `\PR:ZPROG23F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `PROG|ZPROG24F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1`  target = `\PR:ZPROG24F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `PROG|ZPROG4F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG4F\FO:FORM`  target = `\TY:zCdsView1` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `PROG|ZPROG21F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG21F\FO:FORM`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\PR:ZPROG21F\FO:FORM`  target = `\PR:ZPROG21F\FO:SUBFORM` )
                            ( source = `\PR:ZPROG21F\FO:FORM`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `PROG|ZPROG22F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG22F\FO:FORM`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `PROG|ZPROG23F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG23F\FO:FORM`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `PROG|ZPROG24F|FORM` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG24F\FO:FORM`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog_meth DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_form FOR TESTING,
      called_by_function FOR TESTING,
      called_by_method FOR TESTING,
      called_by_program FOR TESTING,
      calls_cds FOR TESTING,
      calls_form FOR TESTING,
      calls_function FOR TESTING,
      calls_method FOR TESTING,
      calls_program FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_prog_meth IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_form.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\FO:FORM`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1` ) ) ).
  ENDMETHOD.

  METHOD called_by_function  ##NEEDED.
    "Nvt
  ENDMETHOD.

  METHOD called_by_method.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS1\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3` ) ) ).
  ENDMETHOD.

  METHOD called_by_program.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD4` ) ) ).
  ENDMETHOD.

  METHOD calls_cds.
    set_unit( `\PR:ZPROG42\TY:LCLASS\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG42\TY:LCLASS\ME:METHOD`  target = `\TY:zCdsView4` ) ) ).

    set_unit( `\PR:ZPROG43\TY:LCLASS\IN:LINTERFACE\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG43\TY:LCLASS\IN:LINTERFACE\ME:METHOD`  target = `\TY:zCdsView4` ) ) ).
  ENDMETHOD.

  METHOD calls_form.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1`  target = `\FG:ZFUGR3\FO:FORM` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1`  target = `\PR:ZPROG25\FO:FORM` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD1`  target = `\PR:ZPROG3F\FO:FORM` ) ) ).
  ENDMETHOD.

  METHOD calls_function.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD2` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD2`  target = `\FG:ZFUGR3\FU:ZFUNC3` ) ) ).
  ENDMETHOD.

  METHOD calls_method.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3`  target = `\PR:ZPROG25\TY:LCLASS3\ME:METHOD` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD3`  target = `\TY:ZCLASS3\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD calls_program.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD4` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD4`  target = `\PR:ZPROG3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_specials DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      alias FOR TESTING,
      includes FOR TESTING,
      include_sap_objects FOR TESTING,
      inheritance FOR TESTING,
      interfaces FOR TESTING,
      local_classes FOR TESTING,
      local_forms FOR TESTING,
      local_interfaces FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_specials IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD alias.
    set_unit( `CLAS|ZCLASS4B` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 0 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZCLASS4\IN:ZINTERFACE4A\ME:METHOD1` )  "komt er standaard bij, helaas
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD2` )  "via alias in super klasse
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD3` )  "alias in tussen klasse
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD4` )  "alias in eigen klasse
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZCLASS4\IN:ZINTERFACE4B\ME:METHOD5` )  "zonder alias
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZINTERFACE4B\ME:METHOD2` )
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZINTERFACE4B\ME:METHOD3` )
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZINTERFACE4B\ME:METHOD4` )
                            ( source = `\TY:ZCLASS4B\IN:ZINTERFACE4A\ME:METHOD1`  target = `\TY:ZINTERFACE4B\ME:METHOD5` ) ) ).
  ENDMETHOD.

  METHOD includes.
    set_unit( `PROG|ZPROG26` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG1\FO:FORM`   target = `\PR:ZPROG26\FO:FORM1` )
                            ( source = `\PR:ZPROG26`          target = `\PR:ZPROG26\FO:FORM` )
                            ( source = `\PR:ZPROG26\FO:FORM`  target = `\PR:ZPROG26\FO:FORM2` ) ) ).
  ENDMETHOD.

  METHOD include_sap_objects.
    set_unit( `PROG|ZPROG3` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          include_sap_objects = abap_true )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG3`  target = `\FG:SRFC\FU:RFC_SYSTEM_INFO` ) ) ).

    set_unit( `FUNC|RFC_SYSTEM_INFO` ).
    cl_abap_unit_assert=>assert_initial( mo_main->run( unit = mo_unit
                                                       depth_calls = 2
                                                       include_sap_objects = abap_false )-calls ).
  ENDMETHOD.

  METHOD inheritance.
    set_unit( `CLAS|ZCLASS4A` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS4A\ME:CONSTRUCTOR`  target = `\FG:ZFUGR3\FU:ZFUNC3` )
                            ( source = `\TY:ZCLASS4A\ME:METHOD3`      target = `\TY:ZCLASS4\ME:METHOD3` )
                            ( source = `\TY:ZCLASS4A\ME:METHOD4`      target = `\TY:ZCLASS4A\ME:METHOD3` )
                            ( source = `\TY:ZCLASS4A\ME:METHOD4`      target = `\TY:ZCLASS4\ME:METHOD3` )
                            ( source = `\TY:ZCLASS4A\ME:METHOD4`      target = `\TY:ZCLASS4\ME:METHOD4` )
                            ( source = `\TY:ZCLASS4A\ME:METHOD5`      target = `\TY:ZCLASS4\ME:METHOD5` ) ) ).
  ENDMETHOD.

  METHOD interfaces.
    set_unit( `CLAS|ZCLASS2|ZINTERFACE2~METHOD` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS1\IN:ZINTERFACE1\ME:METHOD`  target = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD` )
                            ( source = `\TY:ZCLASS1\ME:METHOD`                 target = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZCLASS2\ME:METHOD5` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZCLASS3\IN:ZINTERFACE3\ME:METHOD1` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZCLASS3\IN:ZINTERFACE3\ME:METHOD2` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZINTERFACE3\ME:METHOD1` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZINTERFACE3\ME:METHOD2` )
                            ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZINTERFACE3\ME:METHOD3` ) ) ).

    set_unit( `CLAS|ZCLASS2|METHOD5` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS2\IN:ZINTERFACE2\ME:METHOD`  target = `\TY:ZCLASS2\ME:METHOD5` )
                            ( source = `\TY:ZCLASS2\ME:METHOD5`                target = `\TY:ZCLASS3\IN:ZINTERFACE3\ME:METHOD1` )
                            ( source = `\TY:ZCLASS2\ME:METHOD5`                target = `\TY:ZCLASS3\IN:ZINTERFACE3\ME:METHOD2` )
                            ( source = `\TY:ZCLASS2\ME:METHOD5`                target = `\TY:ZINTERFACE3\ME:METHOD1` )
                            ( source = `\TY:ZCLASS2\ME:METHOD5`                target = `\TY:ZINTERFACE3\ME:METHOD2` )
                            ( source = `\TY:ZCLASS2\ME:METHOD5`                target = `\TY:ZINTERFACE3\ME:METHOD3` ) ) ).
  ENDMETHOD.

  METHOD local_classes.
    set_unit( `CLAS|ZCLASS4|METHOD1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS4\ME:METHOD1`  target = `\TY:ZCLASS4\TY:LCLASS\ME:METHOD` ) ) ).

    set_unit( `CLAS|ZCLASS4|\TY:LCLASS\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZCLASS4\ME:METHOD1`  target = `\TY:ZCLASS4\TY:LCLASS\ME:METHOD` ) ) ).
  ENDMETHOD.

  METHOD local_forms.
    set_unit( `FUNC|ZFUNC41` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR4\FU:ZFUNC41`  target = `\FG:ZFUGR4\FO:GLOBAL_FORM` )
                            ( source = `\FG:ZFUGR4\FU:ZFUNC41`  target = `\FG:ZFUGR4\FO:LOCAL_FORM` )
                            ( source = `\FG:ZFUGR4\FU:ZFUNC41`  target = `\FG:ZFUGR4\FU:ZFUNC42` ) ) ).
    "NB, SAP analyseert *alle* code in de functie dus ook de FORM-code die na de ENDFUNCTION komt!

    set_unit( `FUNC|ZFUNC42` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\FG:ZFUGR4\FO:LOCAL_FORM`  target = `\FG:ZFUGR4\FU:ZFUNC42` ) ) ).
  ENDMETHOD.

  METHOD local_interfaces.
    set_unit( `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS1\IN:LINTERFACE1\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD` )
                            ( source = `\PR:ZPROG25\TY:LCLASS1\ME:METHOD`                 target = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS3\IN:LINTERFACE3\ME:METHOD1` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS3\IN:LINTERFACE3\ME:METHOD2` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD1` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD2` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD3` ) ) ).

    set_unit( `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_calls = 1
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\PR:ZPROG25\TY:LCLASS2\IN:LINTERFACE2\ME:METHOD`  target = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5`                target = `\PR:ZPROG25\TY:LCLASS3\IN:LINTERFACE3\ME:METHOD1` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5`                target = `\PR:ZPROG25\TY:LCLASS3\IN:LINTERFACE3\ME:METHOD2` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5`                target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD1` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5`                target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD2` )
                            ( source = `\PR:ZPROG25\TY:LCLASS2\ME:METHOD5`                target = `\PR:ZPROG25\TY:LINTERFACE3\ME:METHOD3` ) ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_tabl DEFINITION
*--------------------------------------------------------------------*
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM ltcl_unit.

  PRIVATE SECTION.
    METHODS:
      called_by_amdp_method FOR TESTING,
      called_by_cds FOR TESTING.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltcl_tabl IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD called_by_amdp_method.
    set_unit( `TABL|ZTAB5` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:ZAMDP\ME:METHOD1`  target = `\TY:ZTAB5` ) ) ).
  ENDMETHOD.

  METHOD called_by_cds.
    set_unit( `TABL|ZTAB1` ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_main->run( unit = mo_unit
                          depth_where_used = 1 )-calls
      exp = VALUE tt_calls( ( source = `\TY:zCdsView1`  target = `\TY:ZTAB1` ) ) ).
  ENDMETHOD.

ENDCLASS.
