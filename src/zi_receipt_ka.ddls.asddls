@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RECEIPT INTERFACE'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_RECEIPT_KA as select from zreceipt_ka
association to parent ZR_EXPENSE_LINE_KA as _ZR_EXPENSE_LINE_KA
    on $projection.line_number  = _ZR_EXPENSE_LINE_KA.line_number
    
association[1..1] to ZR_EXPENSE_KA as _ZR_EXPENSE_KA
on _ZR_EXPENSE_KA.ex_claim = $projection.ex_claim
{
    key receipt_uuid,
    line_number  ,
    ex_claim,
    @Semantics.largeObject: {
  mimeType: 'mimetype',
  fileName: 'file_name',
  acceptableMimeTypes: [ 'application/pdf' ],
  contentDispositionPreference: #INLINE
    }
    receipt_file,
    
    @Semantics.mimeType: true
    mimetype,
    
    file_name,
        note  ,
    @Semantics.user.createdBy: true
    uploaded_by ,
    @Semantics.systemDateTime.createdAt: true
    uploaded_on ,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_change  ,
    
    _ZR_EXPENSE_LINE_KA, // Make association public
    _ZR_EXPENSE_KA
} 
