@AbapCatalog:{ sqlViewName: 'ZVIEW4', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView4
    as select from ztab4
{
key key1,
key key2,
    value
}
