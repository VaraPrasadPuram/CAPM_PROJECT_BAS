// importing the master data table context
using {CAPM_ONE.db.master} from '../db/datamodel';
using {CAPM_ONE.db.cdsviews} from '../db/cdsviews';

service CatalogService @(path: '/CatalogService') {

    entity EmployeesSet                       as projection on master.Employees;
    entity BusinessPartner                    as projection on master.businesspartner;
    entity Addresses                          as projection on master.Addresses;
    entity Products                           as projection on master.Products;

    define view ProductsValueHelp as
        select from master.Products {
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Product ID'
            }, {
                language: 'DE',
                text    : 'Produkt ID'
            }]
            productId as![ProductId],
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Product Description'
            }, {
                language: 'DE',
                text    : 'Produkt ID'
            }]
            name      as![Name]
        };

    define view![ItemView] as
        select from master.Items {
            poHeader.partner  as![partner],
           key product.productId as![ProductId],
            currency.code     as![CurrencyCode],
            grossAmount       as![Amount],
            netAmount         as![NetAmount],
            taxAmount         as![TaxAmount],
            quantity          as![Quantity],
            quantityUnit      as![QuantityUnit],
            deliveryDate      as![DeliveryDate1]
        };

    define view ProductViewSub as
        select from master.Products as prod {
            productId as ![Product_Id],
            (
                select from master.Items as a {
                    sum(
                        a.grossAmount
                    ) as SUM
                }
                where
                    a.product.productId = prod.productId
            ) as PO_SUM:Integer
        };

    define view ProductView as
        select from master.Products
        mixin {
            PO_ORDERS : Association[ * ] to ItemView
                            on PO_ORDERS.ProductId = $projection.![Product_Id];
        }
        into {
            productId                       as![Product_Id],
            name,
            desc,
            category                        as![Product_Category],
            currency.code                   as![Product_Currency],
            price                           as![Product_Price],
            typeCode                        as![Product_TypeCode],
            weightMeasure                   as![Product_WeightMeasure],
            weightUnit                      as![Product_WeightUnit],
            partner.ID                      as![Supplier_Id],
            partner.ADDRESS_ID.city         as![Supplier_City],
            partner.ADDRESS_ID.postalCode   as![Supplier_PostalCode],
            partner.ADDRESS_ID.street       as![Supplier_Street],
            partner.ADDRESS_ID.building     as![Supplier_Building],
            partner.ADDRESS_ID.country_code as![Supplier_country_code],
            PO_ORDERS
        };


        define view CProductValuesView as
            select from ProductView {
                 Product_Id,
                 PO_ORDERS.CurrencyCode as![CurrencyCode],
                sum(PO_ORDERS.Amount) as![POGrossAmount]:Integer
                 }
                group by
                Product_Id,
                PO_ORDERS.CurrencyCode;
                
   entity ConsumptionView  as projection on CProductValuesView;
   entity PrductViewSub  as projection on ProductViewSub;

    @readonly
    view BusinessAddress @(cds.redirection.target: false) as select from cdsviews.BusinessAddress;


    entity POs @(title: '{i18n>poHeader}')    as projection on master.Headers {
        *,
        item : redirected to POItems
    };

    entity POItems @(title: '{i18n>poItems}') as projection on master.Items {
        *,
        poHeader : redirected to POs,
        product  : redirected to Products
    };


}
