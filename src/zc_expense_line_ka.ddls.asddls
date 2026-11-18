@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION LINE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_EXPENSE_LINE_KA as projection on ZR_EXPENSE_LINE_KA
{
    key line_number,
    line_num,
    ex_claim,
    expense_date,
    category,
    description,
    @Semantics.amount.currencyCode: 'currency'
    amount,
    currency,
    receipt_required,
    number_of_receipts,
    /* Associations */
    _ZI_RECEIPT_KA: redirected to composition child ZC_RECEIPT_KA,
    _ZR_EXPENSE_KA: redirected to parent ZC_EXPENSE_KA
}
