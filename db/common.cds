using {
  sap,
  Currency,
  temporal,
  managed
} from '@sap/cds/common';

namespace CAPM_ONE.common;


annotate temporal with {
  validFrom @(title: '{i18n>validFrom}');
  validTo   @(title: '{i18n>validTo}')
};


  type BusinessKey : String(10);
  type SDate       : DateTime;

  type AmountT     : Decimal(15, 2) @(
    Semantics.amount.currencyCode: 'CURRENCY_code',
    sap.unit                     : 'CURRENCY_code'
  );

  type QuantityT   : Decimal(13, 3) @(title: '{i18n>quantity}');
  type UnitT       : String(3) @title: '{i18n>quantityUnit}';

  type StatusT     : String(1) enum {
    New          = 'N';
    Incomplete   = 'I';
    Approved     = 'A';
    Rejected     = 'R';
    Confirmed    = 'C';
    Saved        = 'S';
    Delivered    = 'D';
    Cancelled    = 'X';
  }

  aspect Amount {
    currency    : Currency;
    grossAmount : AmountT;
    netAmount   : AmountT;
    taxAmount   : AmountT;
  }

  annotate Amount with {
    grossAmount @(title: '{i18n>grossAmount}');
    netAmount   @(title: '{i18n>netAmount}');
    taxAmount   @(title: '{i18n>taxAmount}');
  }

  aspect Quantity {
    quantity     : QuantityT;
    quantityUnit : UnitT;
  }


  type Gender      : String(1) enum {
    male         = 'M';
    female       = 'F';
    nonBinary    = 'N';
    noDisclosure = 'D';
    selfDescribe = 'S';
  }

  annotate Gender with @(
    title      : '{i18n>gender}',
    description: '{i18n>gender}',
    assert.enum
  );

  type Email       : String(255)  @title: '{i18n>email}'  @assert.format: '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
  type PhoneNumber : String(30)  @title: '{i18n>phoneNumber}'  @assert.format: '((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';

