@AbapCatalog:{ sqlViewName: 'ZVIEW5', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView5
    as select from zcdsfunc1
{
key key1,
key key2,
    value
}
