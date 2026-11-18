CLASS zvh_cls_fill_ctg_ka DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZVH_CLS_FILL_CTG_KA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DELETE FROM zctgry_lin_ka.

  DATA CAT TYPE STANDARD TABLE OF zctgry_lin_ka.

    CAT = VALUE #(
      ( vh_number = 1
        category  = 'Flight' )

      ( vh_number = 2
        category  = 'Hotel' )

      ( vh_number = 3
        category  = 'Meals' )

      ( vh_number = 4
        category  = 'Ground Transport' )

      ( vh_number = 5
        category  = 'Other' )
    ).

    INSERT zctgry_lin_ka FROM TABLE @CAT.

  ENDMETHOD.
ENDCLASS.
