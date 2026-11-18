@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VALUE HELP FOR CATEGORY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_VH_CATEGORY_KA as select from zctgry_lin_ka
{
    key vh_number,
    category 
}
