using {
    Currency,
    managed,
    temporal,
    sap,
    cuid
} from '@sap/cds/common';


using {CAPM_ONE.common} from './common';

namespace CAPM_ONE.db; //to determine the uniquness of the Project

type Guid : String(32);

context master {

    entity businesspartner {
        key ID            : Guid;
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(64);
            PHONE_NUMBER  : String(14);
            WEB_ADDRESS   : String(32);
            ADDRESS_ID    : Association to Addresses;
            COMPANY_NAME  : String(64);
            LEGAL_FORM    : String(16);
    }

    annotate businesspartner with {
        BP_ROLE @title: '{i18n>bp_role}';
    }


    entity Addresses : temporal {
        key ID              : Guid;
            city            : String(40);
            postalCode      : String(10);
            street          : String(60);
            building        : String(10);
            country_code    : String(5);
            region          : String(4);
            addressType     : String(2);
            latitude        : Double;
            longitude       : Double;
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_ID = $self;
    }

    annotate Addresses with {
        ID          @title: '{i18n>addressId}';
        city        @title: '{i18n>city}';
        postalCode  @title: '{i18n>postalCode}';
        street      @title: '{i18n>street}';
        building    @title: '{i18n>building}';
        region      @title: '{i18n>region}';
        addressType @title: '{i18n>addressType}';
        latitude    @title: '{i18n>latitude}';
        longitude   @title: '{i18n>longitude}';
    };


    entity Employees : cuid, temporal {
        nameFirst      : String(40);
        nameMiddle     : String(40);
        nameLast       : String(40);
        nameInitials   : String(10);
        sex            : common.Gender;
        language       : String(1);
        phoneNumber    : common.PhoneNumber;
        email          : common.Email;
        loginName      : String(12);
        currency       : Currency;
        salaryAmount   : Decimal(15, 2);
        accountNumber  : String(10);
        bankId         : String(10);
        bankName       : String(255);
        employeePicUrl : String(255);
    }


    annotate Employees with {
        ID             @title: '{i18n>employeeId}';
        nameFirst      @title: '{i18n>fname}';
        nameMiddle     @title: '{i18n>mname}';
        nameLast       @title: '{i18n>lname}';
        nameInitials   @title: '{i18n>initials}';
        language       @title: '{i18n>language}';
        loginName      @title: '{i18n>loginName}';
        salaryAmount   @title: '{i18n>salaryAmount}';
        accountNumber  @title: '{i18n>accountNumber}';
        bankId         @title: '{i18n>bankId}';
        bankName       @title: '{i18n>bankName}';
        employeePicUrl @title: '{i18n>employeePicUrl}';
    };

    entity Products : managed {

        key productId     : String(10);
            typeCode      : String(2);
            category      : String(40);
            name          : localized String;
            desc          : localized String;
            partner       : Association to one master.businesspartner;
            quantity      : Integer;
            quantityUnit  : String(40);
            weightMeasure : Decimal(13, 3);
            weightUnit    : String(3);
            currency      : Currency;
            price         : Decimal(15, 2);
            width         : Decimal(13, 3);
            depth         : Decimal(13, 3);
            height        : Decimal(13, 3);
            dimensionUnit : String(3);
    }


    entity Headers : managed, cuid, common.Amount {
        item                         : Composition of many Items
                                           on item.poHeader = $self;
        noteId                       : common.BusinessKey null;
        partner                      : Association to one master.businesspartner;
        lifecycleStatus              : common.StatusT default 'N';
        approvalStatus               : common.StatusT;
        confirmStatus                : common.StatusT;
        orderingStatus               : common.StatusT;
        invoicingStatus              : common.StatusT;
        @readonly createdByEmployee  : Association to one master.Employees
                                           on createdByEmployee.email = createdBy;
        @readonly modifiedByEmployee : Association to one master.Employees
                                           on modifiedByEmployee.email = modifiedBy;
    }

    entity Items : cuid, common.Amount, common.Quantity {
        poHeader     : Association to Headers;
        product      : Association to one master.Products; //common.BusinessKey;
        noteId       : common.BusinessKey null;
        deliveryDate : common.SDate;
    }

};
