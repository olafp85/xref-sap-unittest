@AbapCatalog:{ sqlViewName: 'ZVIEW7', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView7
    as select from zview6
{
key businesspartnername
}
