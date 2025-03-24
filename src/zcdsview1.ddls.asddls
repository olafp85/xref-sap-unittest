@AbapCatalog:{ sqlViewName: 'ZVIEW1', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView1
    as select from ztab1
    join ztab2 on ztab2.key1 = ztab1.key1
{
key ztab1.key1,
key ztab1.key2,
    ztab2.value
}
