@AbapCatalog:{ sqlViewName: 'ZVIEW3', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView3
    as select from ztab3
{
key key1,
key key2,
    value
}
