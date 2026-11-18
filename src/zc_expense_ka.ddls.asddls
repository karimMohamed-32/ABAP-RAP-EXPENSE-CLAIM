@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION EXPENSE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_EXPENSE_KA 
provider contract transactional_query
as projection on ZR_EXPENSE_KA
{
    key ex_claim,
    claim_number,
    employee_name,
    trip_purpose,
    destination_country,
    trip_start_date,
    trip_end_date,
    currency,
    @Semantics.amount.currencyCode: 'currency'
    total_amount,
    status, 
    colors,
    submitted_on,
    decision_date,
    rejection_reason,
    payment_reference,
    payment_date,
    payment_date_2  ,
    created_by,
    created_on,
    last_change_by,
    last_change_on,
    local_last_change_on,
    reject_reason,
     paidreference ,
    /* Associations */
    _ZR_EXPENSE_LINE_KA : redirected to composition child ZC_EXPENSE_LINE_KA
} 
