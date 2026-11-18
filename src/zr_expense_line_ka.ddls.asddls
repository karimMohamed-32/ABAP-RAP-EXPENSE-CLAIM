@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXPENSE LINE VIEW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_EXPENSE_LINE_KA as select from zexpense_line_ka
composition [0..*] of ZI_RECEIPT_KA as _ZI_RECEIPT_KA
association to parent ZR_EXPENSE_KA as _ZR_EXPENSE_KA 

on _ZR_EXPENSE_KA.ex_claim = $projection.ex_claim
{
    key line_number ,
    line_num,
    ex_claim ,
    expense_date  ,
    category  ,
    description  ,
    @Semantics.amount.currencyCode: 'currency'
    amount ,
    currency  ,
    receipt_required ,
    number_of_receipts,
    
    _ZR_EXPENSE_KA ,
    _ZI_RECEIPT_KA 
}
