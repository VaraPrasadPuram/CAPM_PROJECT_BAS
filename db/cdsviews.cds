namespace CAPM_ONE.db;

using {CAPM_ONE.db.master} from './datamodel';

context cdsviews {

    define view![BusinessAddress] as
        select from master.businesspartner {
            key ID                      as![BusinePartnerId],
                BP_ROLE                 as![BusinePartnerRole],
                EMAIL_ADDRESS           as![EmailAddresses],
                PHONE_NUMBER            as![PhoneNumber],
                WEB_ADDRESS             as![WebAddress],
            key ADDRESS_ID.city         as![City],
                ADDRESS_ID.building     as![Building],
                ADDRESS_ID.country_code as![Country_Code],
                ADDRESS_ID.region       as![Region],
                ADDRESS_ID.street       as![Street]
        };




}
