@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION RECEIPT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_RECEIPT_KA as projection on ZI_RECEIPT_KA
{
    key receipt_uuid,
    line_number,
    ex_claim,
    @Semantics.largeObject: { fileName: 'file_name', mimeType: 'mimetype', acceptableMimeTypes: [ 'application/pdf' ],
    contentDispositionPreference: #INLINE } 
    receipt_file,
    file_name,
    @Semantics.mimeType: true
    mimetype,
    @UI.multiLineText: true
    note,
    uploaded_by,
    uploaded_on,
    local_last_change,
    /* Associations */
    _ZR_EXPENSE_LINE_KA : redirected to parent ZC_EXPENSE_LINE_KA,
    _ZR_EXPENSE_KA: redirected to ZC_EXPENSE_KA
    
}
