@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'VALUE HELP FOR CATEGORY'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZCC_VH_CATEGORY_KA
provider contract transactional_query
as projection on ZC_VH_CATEGORY_KA
{
    @UI.hidden: true
    key vh_number,
    category 
}
