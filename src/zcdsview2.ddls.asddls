@AbapCatalog:{ sqlViewName: 'ZVIEW2', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView2
    as select from zCdsView3
{
key key1,
key key2,
    value
}
