@AbapCatalog:{ sqlViewName: 'ZVIEW8', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView8
    as select from zview
{
key key1,
    key2,
    value
}
