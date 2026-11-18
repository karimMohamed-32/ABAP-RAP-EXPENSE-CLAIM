@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT CDS VIEW'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_EXPENSE_KA as select from zexpense_db_ka
composition[0..*] of  ZR_EXPENSE_LINE_KA as  _ZR_EXPENSE_LINE_KA 
//composition[0..*] of ZI_RECEIPT_KA as _ZI_RECEIPT_KA

{
    @UI.hidden: true
    key ex_claim ,
    claim_number ,
    employee_name ,
    trip_purpose ,
    destination_country ,
    trip_start_date ,
    trip_end_date ,
    currency,
    @Semantics.amount.currencyCode: 'currency'
    total_amount ,
    status ,
    case status
          when 'Open'      then 0
          when 'Submitted' then 2
          when 'Approved'  then 3
          when 'Rejected'  then 1
          when 'Paid'      then 5
          else 0
        end as colors ,
    submitted_on ,
    decision_date  ,
    rejection_reason  ,
    payment_reference  ,
    payment_date  ,
    payment_date_2  ,
    @Semantics.user.createdBy: true
    created_by  ,
    @Semantics.systemDateTime.createdAt: true
    created_on ,
    @Semantics.user.lastChangedBy: true
    last_change_by ,
    @Semantics.systemDateTime.lastChangedAt: true
    last_change_on  ,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_change_on, 
    reject_reason , 
    paidreference ,
    
   _ZR_EXPENSE_LINE_KA   // Make association public

//   _ZI_RECEIPT_KA
} 
