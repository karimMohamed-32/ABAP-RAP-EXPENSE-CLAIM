@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CHECK COUNTRY'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_COUNTRY_KA as select from I_CountryVH
{
    key Country,
    Description,
    @UI.hidden: true
    CountryThreeLetterISOCode,
     @UI.hidden: true
    CountryThreeDigitISOCode,
    /* Associations */
     @UI.hidden: true
    _Text
}
