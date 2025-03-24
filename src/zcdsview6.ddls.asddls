@AbapCatalog:{ sqlViewName: 'ZVIEW6', preserveKey: true }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view zCdsView6
    as select from I_BusinessPartner
    left outer join but001 on but001.partner = I_BusinessPartner.BusinessPartner
    association to I_Username on I_Username.PersonFullName = $projection.BusinessPartnerName
{
key BusinessPartnerName,
    _DefaultAddresses._Address.Country,
    I_Username.UserID
}
