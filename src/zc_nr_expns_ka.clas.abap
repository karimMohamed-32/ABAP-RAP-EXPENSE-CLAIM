CLASS zc_nr_expns_ka DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZC_NR_EXPNS_KA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* DATA: LT_INT TYPE cl_numberrange_intervals=>nr_interval,
*        LS_ERR TYPE  cl_numberrange_intervals=>nr_error,
*        LS_ERR_INFO    type cl_numberrange_intervals=>nr_error_inf,
*        LS_ERROR_IV type cl_numberrange_intervals=>nr_error_iv,
*        LS_WRNG type cl_numberrange_intervals=>nr_warning.
* LT_INT = VALUE #(
* ( nrrangenr = '01' fromnumber = '1000000000' tonumber = '1999999999' )
* ).
*
*
*  TRY.
*      cl_numberrange_intervals=>create(
*        EXPORTING
*          interval  = lt_int
*          object    = 'ZNR_EX_KA'
**      subobject =
**      option    =
*    IMPORTING
*      error     = LS_ERR
*      error_inf = LS_ERR_INFO
*      error_iv  = LS_ERROR_IV
*      warning   = LS_WRNG
*      ).
*    CATCH cx_number_ranges.
*      "handle exception
*  ENDTRY.





DATA: LT_INT TYPE cl_numberrange_intervals=>nr_interval,
        LS_ERR TYPE  cl_numberrange_intervals=>nr_error,
        LS_ERR_INFO    type cl_numberrange_intervals=>nr_error_inf,
        LS_ERROR_IV type cl_numberrange_intervals=>nr_error_iv,
        LS_WRNG type cl_numberrange_intervals=>nr_warning.
 LT_INT = VALUE #(
 ( nrrangenr = '01' fromnumber = '0000000001' tonumber = '0200000000' )
 ).


  TRY.
      cl_numberrange_intervals=>create(
        EXPORTING
          interval  = lt_int
          object    = 'ZLINE_KA'
*      subobject =
*      option    =
    IMPORTING
      error     = LS_ERR
      error_inf = LS_ERR_INFO
      error_iv  = LS_ERROR_IV
      warning   = LS_WRNG
      ).
    CATCH cx_number_ranges.
      "handle exception
  ENDTRY.

  ENDMETHOD.
ENDCLASS.
