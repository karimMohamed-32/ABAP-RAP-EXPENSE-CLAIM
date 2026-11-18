CLASS lhc_zi_receipt_ka DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS receipt_counter FOR DETERMINE ON MODIFY
      keys FOR ZI_RECEIPT_KA~receipt_counter.
    METHODS receipt_size FOR VALIDATE ON SAVE
      keys FOR ZI_RECEIPT_KA~receipt_size.
    METHODS mandatoryFields FOR VALIDATE ON SAVE
      keys FOR ZI_RECEIPT_KA~mandatoryFields.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR ZI_RECEIPT_KA RESULT result.


ENDCLASS.

CLASS lhc_zi_receipt_ka IMPLEMENTATION.

  METHOD receipt_counter.

  READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zi_receipt_ka BY \_zr_expense_line_ka
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).


  READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka BY \_zi_receipt_ka
    ALL FIELDS
    WITH CORRESPONDING #( lt_data )
    RESULT DATA(lt_data_2).

  DATA(r_count) = lines( lt_data_2 ).


  MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    UPDATE FIELDS ( number_of_receipts )
    WITH VALUE #(
      (
        %tky               = lt_data[ 1 ]-%tky
        number_of_receipts = r_count
      )
    ).

  ENDMETHOD.

  METHOD receipt_size.
        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zi_receipt_ka
        FIELDS ( receipt_file )
        WITH CORRESPONDING #( keys )
        RESULT data(lt_receipt).

        LOOP AT lt_receipt ASSIGNING FIELD-SYMBOL(<fs_s>).

            IF xstrlen( <fs_s>-receipt_file ) > 2097152.
              APPEND VALUE #(
                %tky = <fs_s>-%tky
              ) TO failed-zi_receipt_ka.

              APPEND VALUE #(
                %tky = <fs_s>-%tky

                %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text     = | Receipt { <fs_s>-file_name } is larger than 2 MB.  |
                )

                %element-receipt_file = if_abap_behv=>mk-on

              ) TO reported-zi_receipt_ka.
            ENDIF.
        ENDLOOP.
  ENDMETHOD.

  METHOD mandatoryFields.
                READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zi_receipt_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_claims).

        LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_s>).
            if <fs_s>-receipt_file is INITIAL .

                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zi_receipt_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'Receipt cannot be empty.'
              )

              %element-receipt_file = if_abap_behv=>mk-on


            ) TO reported-zi_receipt_ka.

            ENDIF.

        ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

*    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
*    ENTITY zi_receipt_ka by \_zr_expense_ka
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_expense).
*
*  result = VALUE #(
*    FOR z IN lt_expense
*
*    LET is_locked = COND #(
*      WHEN z-status = 'Submitted'
*        OR z-status = 'Approved'
*        OR z-status = 'Paid'
*      THEN abap_true
*      ELSE abap_false )
*
*    IN
*    (
*      %tky = keys[ 1 ]-%tky
*
*      %update = COND #(
*        WHEN is_locked = abap_true
*        THEN if_abap_behv=>fc-o-disabled
*        ELSE if_abap_behv=>fc-o-enabled )
*
*      %delete = COND #(
*        WHEN is_locked = abap_true
*        THEN if_abap_behv=>fc-o-disabled
*        ELSE if_abap_behv=>fc-o-enabled )
*    )
*  ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zr_expense_line_ka DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS TOTALAMOUNT FOR DETERMINE ON MODIFY
      keys FOR ZR_EXPENSE_LINE_KA~TOTALAMOUNT.
    METHODS lineNumber FOR DETERMINE ON MODIFY
      keys FOR ZR_EXPENSE_LINE_KA~lineNumber.
*    METHODS category_description FOR DETERMINE ON MODIFY
*      keys FOR ZR_EXPENSE_LINE_KA~category_description.
    METHODS currency_ref FOR DETERMINE ON MODIFY
      keys FOR ZR_EXPENSE_LINE_KA~currency_ref.
    METHODS R_REQ FOR DETERMINE ON MODIFY
      keys FOR ZR_EXPENSE_LINE_KA~R_REQ.
    METHODS cat_desc FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~cat_desc.
    METHODS EXP_DATE FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~EXP_DATE.
    METHODS AMOUNT_CHK FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~AMOUNT_CHK.
    METHODS required_receipt FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~required_receipt.
    METHODS total_Meals FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~total_Meals.
    METHODS hotel_check FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~hotel_check.
    METHODS mandatoryFields FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_LINE_KA~mandatoryFields.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR ZR_EXPENSE_LINE_KA RESULT result.
*    METHODS receipt_count FOR DETERMINE ON SAVE
*      keys FOR ZR_EXPENSE_LINE_KA~receipt_count.

ENDCLASS.

CLASS lhc_zr_expense_line_ka IMPLEMENTATION.

  METHOD TOTALAMOUNT.
READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka BY \_zr_expense_ka
      FIELDS ( total_amount )
      WITH CORRESPONDING #( keys )
    RESULT DATA(XPNS).

  READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka BY \_ZR_EXPENSE_LINE_KA
      FIELDS ( amount )
      WITH CORRESPONDING #( XPNS )
    RESULT DATA(XPNS_LINES).

  LOOP AT XPNS ASSIGNING FIELD-SYMBOL(<exp>).
    <exp>-total_amount = 0.
  LOOP AT XPNS_LINES INTO DATA(I) WHERE ex_claim = <exp>-ex_claim.
      <exp>-total_amount += I-amount.
    ENDLOOP.
  ENDLOOP.

  MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
      UPDATE FIELDS ( total_amount )
      WITH CORRESPONDING #( xpns ).

  ENDMETHOD.

METHOD lineNumber.

  READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    FIELDS ( ex_claim line_num )
    WITH CORRESPONDING #( keys )
    RESULT DATA(data_lines).

  LOOP AT data_lines INTO DATA(s_line).

    IF s_line-line_num IS NOT INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
      ENTITY zr_expense_line_ka BY \_zr_expense_ka
      FIELDS ( ex_claim )
      WITH VALUE #(
        ( %tky = s_line-%tky )
      )
      RESULT DATA(s_expns).

    IF s_expns IS INITIAL.
      CONTINUE.
    ENDIF.

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
      ENTITY zr_expense_ka BY \_zr_expense_line_ka
      FIELDS ( ex_claim line_num )
      WITH CORRESPONDING #( s_expns )
      RESULT DATA(lt_claim_lines)
      FAILED DATA(lt_lines_failed).


    DATA lv_max_line_num TYPE i VALUE 0.

    LOOP AT lt_claim_lines INTO DATA(ls_claim_line).

      IF ls_claim_line-line_num IS NOT INITIAL.

        DATA(lv_existing_line_num) =
          CONV i( ls_claim_line-line_num ).

        IF lv_existing_line_num > lv_max_line_num.
          lv_max_line_num = lv_existing_line_num.
        ENDIF.

      ENDIF.

    ENDLOOP.

    DATA(lv_next_line_num) = lv_max_line_num + 10.

    MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
      ENTITY zr_expense_line_ka
      UPDATE FIELDS ( line_num )
      WITH VALUE #(
        (
          %tky     = s_line-%tky
          line_num = CONV zexpense_line_ka-line_num(
                         lv_next_line_num
                       )
        )
      )
      FAILED DATA(lt_update_failed)
      REPORTED DATA(lt_update_reported).

  ENDLOOP.

ENDMETHOD.



  METHOD currency_ref.

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka BY \_zr_expense_ka
    FIELDS ( currency )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_parent).

  READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    FIELDS ( line_number )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_line).

  IF lt_parent IS INITIAL OR lt_line IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lv_currency) = lt_parent[ 1 ]-currency.

  MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    UPDATE FIELDS ( currency )
    WITH VALUE #(
      (
        %tky = lt_line[ 1 ]-%tky
        currency    = lv_currency
      )
    )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD R_REQ.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(LT_DATA).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<FS_S>).
        IF <FS_S>-amount > 50 and <FS_S>-currency = 'EUR'.
            <FS_S>-receipt_required = 'YES'.
            ELSE .
            <FS_S>-receipt_required = 'NO'.
        ENDIF.

     ENDLOOP.

        MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka
      UPDATE FIELDS ( receipt_required ) with VALUE #( ( %tky = keys[ 1 ]-%tky receipt_required =  <FS_S>-receipt_required ) )
        FAILED   DATA(lt_failed)
        REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD cat_desc.

     READ ENTITIES OF zr_expense_ka  IN LOCAL MODE
  ENTITY zr_expense_line_ka
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_data).

  LOOP AT lt_data ASSIGNING  FIELD-SYMBOL(<fs_s>).
    if ( <fs_s>-category = 'Other' or <fs_s>-category is INITIAL
*    OR <fs_s>-category <> 'Ground Transport' OR <fs_s>-category <> 'Meals' OR <fs_s>-category <>
*        'Flight' OR <fs_s>-category <> 'Hotel'
     ) and <fs_s>-description is INITIAL.

    APPEND VALUE #(
        %tky = <fs_s>-%tky
      ) TO failed-zr_expense_line_ka.

        APPEND  VALUE #(

          %tky = <fs_s>-%tky
          %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = |Line { <fs_s>-line_num } : please choose a valid category. A description is required for category Other.|   )

        %element-description = if_abap_behv=>mk-on

      ) TO reported-zr_expense_line_ka.
    ENDIF.

  ENDLOOP.

  ENDMETHOD.

  METHOD EXP_DATE.

        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka
        FIELDS ( expense_date )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_lines).

      READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka BY \_zr_expense_ka
        FIELDS ( trip_start_date trip_end_date )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_parent).

      DATA(ls_parent) = lt_parent[ 1 ].

      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<FS_S>).

        IF <FS_S>-expense_date < ls_parent-trip_start_date OR <FS_S>-expense_date > ls_parent-trip_end_date.

          APPEND VALUE #(
            %tky = <FS_S>-%tky
          ) TO failed-zr_expense_line_ka.

          APPEND VALUE #(
            %tky = <FS_S>-%tky

            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = | Line { <FS_S>-line_num }: expense date <date> is outside the trip dates. |
            )

            %element-expense_date = if_abap_behv=>mk-on

          ) TO reported-zr_expense_line_ka.

        ENDIF.

      ENDLOOP.

  ENDMETHOD.

  METHOD AMOUNT_CHK.
       READ ENTITIES OF zr_expense_ka IN LOCAL MODE
       ENTITY zr_expense_line_ka
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(LT_LINE).

       LOOP AT lt_line ASSIGNING FIELD-SYMBOL(<FS_S>).
            IF  <fs_s>-amount <= 0.
                APPEND VALUE #( %TKY = <fs_s>-%tky ) TO failed-zr_expense_line_ka.
                 APPEND VALUE #(
                    %tky = <FS_S>-%tky

                    %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = | Line { <FS_S>-line_num } : amount must be greater than zero.|
                    )

                    %element-AMOUNT = if_abap_behv=>mk-on

                  ) TO reported-zr_expense_line_ka.

            ENDIF.
       ENDLOOP.

  ENDMETHOD.

  METHOD required_receipt.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    FIELDS ( receipt_required )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_line).

  LOOP AT lt_line ASSIGNING FIELD-SYMBOL(<fs_line>).

    IF <fs_line>-receipt_required = 'YES'.

      READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka BY \_zi_receipt_ka
        FIELDS ( receipt_uuid )
        WITH VALUE #(
          ( %tky = <fs_line>-%tky )
        )
        RESULT DATA(lt_receipt).

      IF lt_receipt IS INITIAL.

        APPEND VALUE #(
          %tky = <fs_line>-%tky
        ) TO failed-zr_expense_line_ka.

        APPEND VALUE #(
          %tky = <fs_line>-%tky

          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = | Line {  <fs_line>-line_num }: a receipt is required for amounts above EUR 50.00. |
          )

          %element-receipt_required = if_abap_behv=>mk-on

        ) TO reported-zr_expense_line_ka.

      ENDIF.

    ENDIF.

  ENDLOOP.

  ENDMETHOD.

  METHOD total_Meals.

      READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_s>).

        IF <fs_s>-category = 'Meals' and <fs_s>-currency = 'EUR'.

          DATA(lv_total) = 0.

          LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_meal>)
            WHERE category     = 'Meals' and currency     = 'EUR' and expense_date = <fs_s>-expense_date.

            lv_total += <fs_meal>-amount.

          ENDLOOP.

          IF lv_total > 75.

            APPEND VALUE #(
              %tky = <fs_s>-%tky
            ) TO failed-zr_expense_line_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = | Meals on { <fs_s>-expense_date } total { <fs_s>-amount }>, which exceeds the daily limit of EUR 75.00. |
              )

              %element-amount = if_abap_behv=>mk-on

            ) TO reported-zr_expense_line_ka.

          ENDIF.

        ENDIF.

      ENDLOOP.
  ENDMETHOD.

  METHOD hotel_check.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).

  LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_s>).

    IF <fs_s>-category = 'Hotel'.

      DATA(lv_count) = 0.

      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_hotel>)
        WHERE category     = 'Hotel' and expense_date = <fs_s>-expense_date
        and ex_claim = <fs_s>-ex_claim.
        lv_count += 1.

      ENDLOOP.

      IF lv_count > 1.

        APPEND VALUE #(
          %tky = <fs_s>-%tky
        ) TO failed-zr_expense_line_ka.

        APPEND VALUE #(
          %tky = <fs_s>-%tky

          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Only one hotel line is allowed per date ({ <fs_s>-expense_date }). |
          )

          %element-expense_date = if_abap_behv=>mk-on

        ) TO reported-zr_expense_line_ka.

      ENDIF.

    ENDIF.

  ENDLOOP.
  ENDMETHOD.


  METHOD mandatoryFields.
                READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_line_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_claims).

        LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_s>).
            if <fs_s>-expense_date is INITIAL or <fs_s>-category is INITIAL or <fs_s>-amount is INITIAL.

                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_line_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'Please fill all Mandatory fields.'
              )

              %element-expense_date = if_abap_behv=>mk-on
              %element-category = if_abap_behv=>mk-on
              %element-amount = if_abap_behv=>mk-on


            ) TO reported-zr_expense_line_ka.

            ENDIF.

        ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.
        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_line_ka by \_zr_expense_ka
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_expense).

  result = VALUE #(
    FOR z IN lt_expense

    LET is_locked = COND #(
      WHEN z-status = 'Submitted'
        OR z-status = 'Approved'
        OR z-status = 'Paid'
      THEN abap_true
      ELSE abap_false )

    IN
    (
      %tky = keys[ 1 ]-%tky

      %update = COND #(
        WHEN is_locked = abap_true
        THEN if_abap_behv=>fc-o-disabled
        ELSE if_abap_behv=>fc-o-enabled )
        %assoc-_zi_receipt_ka = COND #(
            WHEN is_locked = abap_true
            THEN if_abap_behv=>fc-o-disabled
            ELSE if_abap_behv=>fc-o-enabled )
      %delete = COND #(
        WHEN is_locked = abap_true
        THEN if_abap_behv=>fc-o-disabled
        ELSE if_abap_behv=>fc-o-enabled )
    )
  ).




  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZR_EXPENSE_KA DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zr_expense_ka RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zr_expense_ka RESULT result.
    METHODS claimnumber FOR DETERMINE ON save
      keys FOR zr_expense_ka~claimnumber.
    METHODS claimcurr FOR DETERMINE ON MODIFY
      keys FOR zr_expense_ka~claimcurr.
    METHODS trip_date FOR VALIDATE ON SAVE
      keys FOR zr_expense_ka~trip_date.
    METHODS country_check FOR VALIDATE ON SAVE
      keys FOR zr_expense_ka~country_check.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR zr_expense_ka RESULT result.
    METHODS claimstatus FOR DETERMINE ON MODIFY
      keys FOR zr_expense_ka~claimstatus.
*    METHODS currency FOR DETERMINE ON MODIFY
*      keys FOR zr_expense_ka~currency.
    METHODS Submit FOR MODIFY
      IMPORTING keys FOR ACTION zr_expense_ka~Submit RESULT result.
    METHODS Approved FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~Approved RESULT result.
    METHODS Paid FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~Paid RESULT result.

    METHODS Rejected FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~Rejected RESULT result.

    METHODS mandatoryFields FOR VALIDATE ON SAVE
      keys FOR ZR_EXPENSE_KA~mandatoryFields.
    METHODS Withdraw FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~Withdraw RESULT result.
    METHODS Mass_approval FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~Mass_approval RESULT result.
    METHODS CopyClaim FOR MODIFY
      keys FOR ACTION ZR_EXPENSE_KA~CopyClaim.


ENDCLASS.

CLASS lhc_ZR_EXPENSE_KA IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD ClaimNumber.

  TRY.
      cl_numberrange_runtime=>number_get(
        EXPORTING
*      ignore_buffer     =
          nr_range_nr       = '01'
          object            = 'ZNR_EX_KA'
    IMPORTING
      number            = data(claim_num)

      ).
    CATCH cx_number_ranges.
      "handle exception
  ENDTRY.
*  CATCH cx_nr_object_not_found.
*  CATCH cx_number_ranges.

        MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka
        UPDATE SET FIELDS WITH VALUE #(
                    (  %tky = keys[ 1 ]-%tky
                    claim_number = claim_num )
        ) MAPPED data(claim_mpd) REPORTED data(claim_rprt) FAILED data(claim_fail) .


  ENDMETHOD.

  METHOD trip_date.

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_s>).
        if <fs_s>-trip_end_date < <fs_s>-trip_start_date.

            APPEND VALUE #( %tky =  <fs_s>-%tky )  TO failed-zr_expense_ka.

            APPEND VALUE #(

            %tky = <fs_s>-%tky
            %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = |Trip end date { <fs_s>-trip_end_date } is before trip start date { <fs_s>-trip_start_date }. | )
           %element-trip_end_date  = if_abap_behv=>mk-on
    ) TO reported-zr_expense_ka.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD claimcurr.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_curr).

    LOOP AT lt_curr ASSIGNING FIELD-SYMBOL(<fs_curr>).

    if <fs_curr>-status is NOT INITIAL.
        <fs_curr>-currency = 'EUR'.
    ENDIF.

    MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    UPDATE SET FIELDS WITH VALUE #(
               (  %tky = keys[ 1 ]-%tky
                currency = <fs_curr>-currency )
    ).


    ENDLOOP.

  ENDMETHOD.

  METHOD country_check.

*    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
*    ENTITY zr_expense_ka
*    FIELDS ( destination_country )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_country).
*
*    DATA(LV_SS) TYPE ZI_COUNTRY_KA.
*   LOOP AT lt_country ASSIGNING FIELD-SYMBOL(<fs_s>).
*
*    IF <fs_s>-destination_country NOT IN .
*
*      APPEND VALUE #(
*        %tky = <fs_s>-%tky
*      ) TO failed-zr_expense_ka.
*
*      APPEND VALUE #(
*        %tky = <fs_s>-%tky
*
*        %msg = new_message_with_text(
*          severity = if_abap_behv_message=>severity-error
*          text     = 'Destination country not exist'
*        )
*
*        %element-destination_country = if_abap_behv=>mk-on
*
*      ) TO reported-zr_expense_ka.
*
*    ENDIF.
*
*  ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

*    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
*    ENTITY zr_expense_ka
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_EPNS).
*
*  result = VALUE #(
*    FOR S IN lt_EPNS
*    (
*      %tky = S-%tky
*
*      %field-currency =
*        COND #( WHEN S-claim_number IS not INITIAL
*            THEN if_abap_behv=>fc-f-read_only
*          ELSE
*            if_abap_behv=>fc-f-unrestricted
*        )
*    )
*  ).
**********************************************************************
*    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
*    ENTITY zr_expense_ka
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_expense).
*
*  result = VALUE #(
*    FOR z IN lt_expense
*
*    LET is_locked = COND #(
*      WHEN z-status = 'Submitted'
*        OR z-status = 'Approved'
*        OR z-status = 'Paid'
*      THEN abap_true
*      ELSE abap_false )
*
*    IN
*    (
*      %tky = z-%tky
*
*      %update = COND #(
*        WHEN is_locked = abap_true
*        THEN if_abap_behv=>fc-o-disabled
*        ELSE if_abap_behv=>fc-o-enabled )
*
*    %assoc-_zr_expense_line_ka = COND #(
*            WHEN is_locked = abap_true
*            THEN if_abap_behv=>fc-o-disabled
*            ELSE if_abap_behv=>fc-o-enabled )
*
*      %delete = COND #(
*        WHEN is_locked = abap_true
*        THEN if_abap_behv=>fc-o-disabled
*        ELSE if_abap_behv=>fc-o-enabled )
*
*     %field-currency =
*        COND #( WHEN z-claim_number IS not INITIAL
*            THEN if_abap_behv=>fc-f-read_only
*          ELSE
*            if_abap_behv=>fc-f-unrestricted
*        )
*    )
*
*  ).

   READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_expense_2).


  result = VALUE #(

    FOR z IN lt_expense_2

    (
      %tky = z-%tky

      %update = COND #(
        WHEN z-status = 'Open'
          OR z-status = 'Rejected'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

      %delete = COND #(
        WHEN z-status = 'Open'
          OR z-status = 'Rejected'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )


      %assoc-_zr_expense_line_ka = COND #(
        WHEN z-status = 'Open'
          OR z-status = 'Rejected'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

  %action-Submit = COND #(
    WHEN z-status = 'Open'
      OR z-status = 'Rejected'
    THEN if_abap_behv=>fc-o-enabled
    ELSE if_abap_behv=>fc-o-disabled
  )


      %action-Withdraw = COND #(
        WHEN z-status = 'Submitted'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

      %action-Approved = COND #(
        WHEN z-status = 'Submitted'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

      %action-Rejected = COND #(
        WHEN z-status = 'Submitted'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

      %action-Paid = COND #(
        WHEN z-status = 'Approved'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled
      )

    )
  ).

  ENDMETHOD.

  METHOD claimstatus.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    FIELDS ( status ) WITH CORRESPONDING #( keys )
    RESULT data(lt_claims).

    loop AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_s>).
        if <fs_s>-status is INITIAL.
            <fs_s>-status = 'Open' .
        ENDIF.

    MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    UPDATE FIELDS ( status payment_reference rejection_reason payment_date_2 decision_date ) WITH VALUE #(
            ( %tky = keys[ 1 ]-%tky
               status = <fs_s>-status
               payment_reference = ' '
               rejection_reason = ' '
               payment_date_2 = ' '
               decision_date = ' '
            )
    ).


    ENDLOOP.

  ENDMETHOD.

  METHOD Submit.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_claims).

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka by \_zr_expense_line_ka
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_claims_2).

    data(lv_expnsLine) = lines( lt_claims_2 ).

    LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_s>).

        if <fs_s>-status = 'Paid' or <fs_s>-status = 'Approved'.
           APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = | Claim { <fs_s>-claim_number } cannot be submitted: The status must be Open or Rejected.|
              )

            ) TO reported-zr_expense_ka.
            elseif lv_expnsLine = 0  .
                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = | Claim { <fs_s>-claim_number } cannot be submitted: Expense line or more is required for submitting.|
              )

            ) TO reported-zr_expense_ka.

            ELSEIF <fs_s>-trip_end_date > cl_abap_context_info=>get_system_date( ) .
                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = |Claim { <fs_s>-claim_number } cannot be submitted: Trip End Date must be today or earlier.|
              )

            ) TO reported-zr_expense_ka.
             ELSE.

               MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
                ENTITY zr_expense_ka
                UPDATE FIELDS ( status submitted_on ) WITH VALUE #(
                    ( %tky   = <fs_s>-%tky
                    status = 'Submitted'
                    submitted_on = cl_abap_context_info=>get_system_date( ) )
                ).
    APPEND VALUE #(
                  %tky = <fs_s>-%tky

                  %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-success
                    text     = |Claim { <fs_s>-claim_number } has been Submitted|
                  )

                ) TO reported-zr_expense_ka.

            ENDIF.

                ENDLOOP.


    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

    result = VALUE #(
        FOR z2 IN lt_result
        (
          %tky   = z2-%tky
          %param = z2
        )
      ).
  ENDMETHOD.

  METHOD Approved.

    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_expns).

    LOOP AT lt_expns ASSIGNING FIELD-SYMBOL(<fs_s>).
        if <fs_s>-total_amount > 5000 and <fs_s>-currency = 'EUR'.
                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = |Claim { <fs_s>-claim_number } exceeds the approval limit of EUR 5,000.00 and requires Director approval. |
              )

            ) TO reported-zr_expense_ka.
             ELSE.

               MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
                ENTITY zr_expense_ka
                UPDATE FIELDS ( status decision_date ) WITH VALUE #(
                    ( %tky   = <fs_s>-%tky
                    status = 'Approved'
                    decision_date = cl_abap_context_info=>get_system_date( ) )
                ).

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-success
                text     = |Claim { <fs_s>-claim_number } has been Approved |
              )

            ) TO reported-zr_expense_ka.
        ENDIF.

    ENDLOOP.


    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_claims).

     result = VALUE #(
        FOR z2 IN lt_claims
        (
          %tky   = z2-%tky
          %param = z2
        )
      ).

  ENDMETHOD.

  METHOD Paid.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
            ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT data(lt_expense).
       LOOP AT lt_expense ASSIGNING FIELD-SYMBOL(<fs_s_2>).
            if <fs_s_2>-status <> 'Approved'.
            APPEND VALUE #(
          %tky = <fs_S_2>-%tky
        ) TO failed-zr_expense_ka.

        APPEND VALUE #(
          %tky = <fs_S_2>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Status mus be Approved before reject.'
          )
        ) TO reported-zr_expense_ka.

        else.
    LOOP AT keys ASSIGNING  FIELD-SYMBOL(<FS_S>).

    DATA(LV_REFERENCE) = <FS_S>-%param-paidReference.

    IF LV_REFERENCE IS INITIAL.


    APPEND VALUE #(
      %tky = <FS_S>-%tky
    ) TO failed-zr_expense_ka.

    APPEND VALUE #(
      %tky = <FS_S>-%tky
      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Please enter a payment reference.'
      )
    ) TO reported-zr_expense_ka.



  elseif LV_REFERENCE IS not INITIAL.

    MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    UPDATE FIELDS ( status payment_reference payment_date_2 rejection_reason ) with VALUE #(
        for z in keys ( %tky = z-%tky
        status = 'Paid'
        payment_reference =  LV_REFERENCE
        payment_date_2 = cl_abap_context_info=>get_system_date( )
        rejection_reason = ' ' )
    ).




    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_claims).

     result = VALUE #(
        FOR z2 IN lt_claims
        (
          %tky   = z2-%tky
          %param = z2
        )
      ).


APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-success
                text     = |Claim has been Paid|
              )

            ) TO reported-zr_expense_ka.
    ENDIF.
    ENDLOOP.
ENDIF.
ENDLOOP.

  ENDMETHOD.

  METHOD Rejected.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_expense).
   LOOP AT lt_expense ASSIGNING FIELD-SYMBOL(<fs_s_2>).
        if <fs_s_2>-status <> 'Submitted'.
        APPEND VALUE #(
      %tky = <fs_S_2>-%tky
    ) TO failed-zr_expense_ka.

    APPEND VALUE #(
      %tky = <fs_S_2>-%tky
      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'The status mus be submitted before reject.'
      )
    ) TO reported-zr_expense_ka.

    else.

  LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_S>).

  DATA(lv_reason) = <fs_S>-%param-reject_reason.
    if lv_reason is INITIAL or strlen( lv_reason ) < 15.
    APPEND VALUE #(
      %tky = <fs_S>-%tky
    ) TO failed-zr_expense_ka.

    APPEND VALUE #(
      %tky = <fs_S>-%tky
      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Please enter a rejection reason of at least 15 characters.'
      )
    ) TO reported-zr_expense_ka.

  else.

  MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka
    UPDATE FIELDS ( status rejection_reason decision_date payment_date_2 payment_reference )
    WITH VALUE #(
      (
        %tky             = <fs_S>-%tky
        status           = 'Rejected'
        rejection_reason = lv_reason
        decision_date = cl_abap_context_info=>get_system_date( )
        payment_date_2 = ' '
        payment_reference = ' '
      )
    ).

APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-success
                text     = |Claim has been Rejected|
              )

            ) TO reported-zr_expense_ka.
    READ ENTITIES OF zr_expense_ka IN LOCAL MODE
    ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT data(lt_claims).

     result = VALUE #(
        FOR z2 IN lt_claims
        (
          %tky   = z2-%tky
          %param = z2
        )
      ).
      endif.
ENDLOOP.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD mandatoryFields.
        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_claims).

        LOOP AT lt_claims ASSIGNING FIELD-SYMBOL(<fs_s>).
            if <fs_s>-employee_name is INITIAL or <fs_s>-trip_purpose is INITIAL or <fs_s>-destination_country is INITIAL
            or <fs_s>-trip_start_date is INITIAL or <fs_s>-trip_end_date is INITIAL or <fs_s>-currency is INITIAL.

                APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'Please fill all Mandatory fields.'
              )

              %element-employee_name = if_abap_behv=>mk-on
              %element-trip_purpose = if_abap_behv=>mk-on
              %element-destination_country = if_abap_behv=>mk-on
              %element-trip_start_date = if_abap_behv=>mk-on
              %element-trip_end_date = if_abap_behv=>mk-on
              %element-currency = if_abap_behv=>mk-on


            ) TO reported-zr_expense_ka.

            ENDIF.

        ENDLOOP.

  ENDMETHOD.


  METHOD Withdraw.

        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_expns).

       LOOP AT lt_expns ASSIGNING FIELD-SYMBOL(<fs_s>).

            if <fs_s>-status <> 'Submitted'.

             APPEND VALUE #(
              %tky = <fs_s>-%tky
                ) TO failed-zr_expense_ka.

            APPEND VALUE #(
              %tky = <fs_s>-%tky

              %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'For Withdraw the status must be Submitted .'
              ) ) to reported-zr_expense_ka.

      else.
        MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka
        UPDATE FIELDS ( status rejection_reason ) WITH value #(
        ( %tky = keys[ 1 ]-%tky
        status = 'Open'
        rejection_reason = ' ' ) ).

        ENDIF.
        ENDLOOP.

        READ ENTITIES OF zr_expense_ka IN LOCAL MODE
        ENTITY zr_expense_ka ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT data(lt_withdraw).

        result = value #(
            for z2 in lt_withdraw (
                %tky = z2-%tky
                %param = z2
            )
         ).
  ENDMETHOD.

  METHOD Mass_approval.

  DATA lv_count      TYPE i.

  data(lvMax_Amount) = keys[ 1 ]-%param-MaximumAmount.

  IF lvMax_Amount > 5000 .


      APPEND VALUE #(
        %cid = keys[ 1 ]-%cid
      ) TO failed-zr_expense_ka.

      APPEND VALUE #(
        %cid = keys[ 1 ]-%cid

        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Maximum amount cannot exceed EUR 5,000.'
        )
      ) TO reported-zr_expense_ka.

    RETURN.
  ENDIF.

  SELECT ex_claim, claim_number
  FROM zr_expense_ka
  WHERE status       = 'Submitted'
    AND total_amount <= @lvMax_Amount
  INTO TABLE @DATA(lt_claims).

IF lt_claims IS INITIAL.

  APPEND VALUE #(
    %cid = keys[ 1 ]-%cid
    %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-information
      text     = 'No submitted claims qualify.'
    )
  ) TO reported-zr_expense_ka.

  RETURN.

ENDIF.


MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE
  ENTITY zr_expense_ka
    UPDATE FIELDS ( status decision_date )
    WITH VALUE #(
      FOR z IN lt_claims
      (
        ex_claim      = z-ex_claim
        status        = 'Approved'
        decision_date = cl_abap_context_info=>get_system_date( )
      )
    )
  FAILED DATA(lt_failed)
  REPORTED DATA(lt_reported).


 IF lt_failed IS NOT INITIAL.

    APPEND VALUE #(
      %cid = keys[ 1 ]-%cid

      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Some claims could not be approved.'
      )
    ) TO reported-zr_expense_ka.

    RETURN.

  ENDIF.
lv_count = lines( lt_claims ).

APPEND VALUE #(
  %cid = keys[ 1 ]-%cid
  %msg = new_message_with_text(
    severity = if_abap_behv_message=>severity-success
    text     = |{ lv_count } claims approved.|
  )
) TO reported-zr_expense_ka.

  ENDMETHOD.

METHOD CopyClaim.

  READ ENTITIES OF zr_expense_ka IN LOCAL MODE

    ENTITY zr_expense_ka
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_claims)

    ENTITY zr_expense_ka BY \_zr_expense_line_ka
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lines).

  IF lt_claims IS INITIAL.
    RETURN.
  ENDIF.


  READ ENTITIES OF zr_expense_ka IN LOCAL MODE

    ENTITY zr_expense_line_ka BY \_zi_receipt_ka
      ALL FIELDS
      WITH CORRESPONDING #( lt_lines )
      RESULT DATA(lt_receipts).


  DATA(lv_claim_cid) = keys[ 1 ]-%cid.

  IF lv_claim_cid IS INITIAL.
    lv_claim_cid = 'NEW_CLAIM'.
  ENDIF.

  DATA lt_line_create TYPE TABLE FOR CREATE zr_expense_ka\_zr_expense_line_ka.
  DATA lt_receipt_create TYPE TABLE FOR CREATE zr_expense_line_ka\_zi_receipt_ka.


  LOOP AT lt_lines INTO DATA(ls_line).

    DATA(lv_line_index) = sy-tabix.
    DATA(lv_line_cid)   = |NEW_LINE_{ lv_line_index }|.


    APPEND VALUE #(
      %cid_ref = lv_claim_cid

      %target = VALUE #(
        (
          %cid = lv_line_cid
          line_num           = ls_line-line_num
          expense_date       = ls_line-expense_date
          category           = ls_line-category
          description        = ls_line-description
          amount             = ls_line-amount
          currency           = ls_line-currency
          receipt_required   = ls_line-receipt_required
          number_of_receipts = ls_line-number_of_receipts
        )
      )
    ) TO lt_line_create.

    DATA(lv_receipt_index) = 0.

    LOOP AT lt_receipts INTO DATA(ls_receipt)
      WHERE line_number = ls_line-line_number.

      lv_receipt_index = lv_receipt_index + 1.

      APPEND VALUE #(
        %cid_ref = lv_line_cid

        %target = VALUE #(
          (
            %cid =
              |NEW_RECEIPT_{ lv_line_index }_{ lv_receipt_index }|

            receipt_file = ls_receipt-receipt_file
            file_name    = ls_receipt-file_name
            mimetype     = ls_receipt-mimetype
            note         = ls_receipt-note
          )
        )
      ) TO lt_receipt_create.

    ENDLOOP.

  ENDLOOP.

  MODIFY ENTITIES OF zr_expense_ka IN LOCAL MODE

    ENTITY zr_expense_ka
      CREATE FIELDS (
        currency
        destination_country
        employee_name
        status
        total_amount
        trip_end_date
        trip_purpose
        trip_start_date
      )

      WITH VALUE #(
        FOR zc IN lt_claims
        (
          %cid = lv_claim_cid
          currency            = zc-currency
          destination_country = zc-destination_country
          employee_name       = zc-employee_name
          trip_start_date     = zc-trip_start_date
          trip_end_date       = zc-trip_end_date
          total_amount        = zc-total_amount

          trip_purpose = |Copy of { zc-trip_purpose }|
          status       = 'Open'
        )
      )

    ENTITY zr_expense_ka
      CREATE BY \_zr_expense_line_ka
      FIELDS (
        line_num
        expense_date
        category
        description
        amount
        currency
        receipt_required
        number_of_receipts
      )
      WITH lt_line_create


    "Copied receipts
    ENTITY zr_expense_line_ka CREATE BY \_zi_receipt_ka
      FIELDS (
        receipt_file
        file_name
        mimetype
        note
      )
      WITH lt_receipt_create


    MAPPED DATA(mapped_copy)
    FAILED DATA(failed_copy)
    REPORTED DATA(reported_copy).


  IF failed_copy IS NOT INITIAL.
    RETURN.
  ENDIF.


  APPEND VALUE #(
    %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-success
      text =
        |Claim { lt_claims[ 1 ]-claim_number } was copied successfully.|
    )
  ) TO reported-zr_expense_ka.

ENDMETHOD.

ENDCLASS.
