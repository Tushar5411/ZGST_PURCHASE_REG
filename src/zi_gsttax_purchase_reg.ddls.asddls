@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Purchase Reg'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@UI.presentationVariant: [
  {
    sortOrder: [
      { by: 'AccountingDocument', direction: #ASC },
      { by: 'AccountingDocumentItem', direction: #ASC }
    ]
  }
]

define root view entity ZI_GSTTAX_PURCHASE_REG
  as select from

                    I_OperationalAcctgDocItem      as Item

    inner join      I_JournalEntry                 as JE            on  Item.CompanyCode        = JE.CompanyCode
                                                                    and Item.FiscalYear         = JE.FiscalYear
                                                                    and Item.AccountingDocument = JE.AccountingDocument

    inner join      I_OperationalAcctgDocItem      as Item_2        on  Item_2.CompanyCode                =  Item.CompanyCode
                                                                    and Item_2.FiscalYear                 =  Item.FiscalYear
                                                                    and Item_2.AccountingDocument         =  Item.AccountingDocument
                                                                    and Item_2.TaxItemGroup               =  Item.TaxItemGroup
                                                                    and Item_2.AccountingDocumentItemType <> 'T'

    left outer join I_BusinessPlaceVH              as BUSPLACE      on  BUSPLACE.CompanyCode   = Item.CompanyCode
                                                                    and BUSPLACE.BusinessPlace = Item.BusinessPlace

    left outer join I_OperationalAcctgDocItem      as Item_3        on  Item_3.CompanyCode          = Item.CompanyCode
                                                                    and Item_3.FiscalYear           = Item.FiscalYear
                                                                    and Item_3.AccountingDocument   = Item.AccountingDocument
                                                                    and Item_3.FinancialAccountType = 'K'

    left outer join I_BusinessPartner              as BUSPARTNER    on BUSPARTNER.BusinessPartner = Item_3.Supplier

    left outer join I_Businesspartnertaxnumber     as gstin         on  gstin.BusinessPartner = Item_3.Supplier
                                                                    and gstin.BPTaxType       = 'IN3'

    left outer join I_TaxCodeText                  as _TaxCode      on  _TaxCode.TaxCode  = Item.TaxCode
                                                                    and _TaxCode.Language = 'E'

    left outer join I_GLAccountText                as glacc         on  glacc.GLAccount = Item.GLAccount
                                                                    and glacc.Language  = 'E'

    left outer join I_ProductText                  as mtext         on  mtext.Product  = Item_2.Product
                                                                    and mtext.Language = 'E'


    left outer join I_BusinessPartnerLegalFormText as LegalFormtext on  LegalFormtext.LegalForm = BUSPARTNER.LegalForm
                                                                    and LegalFormtext.Language  = 'E'

    left outer join I_BusinessPartnerTypeText      as bptypetext    on  bptypetext.BusinessPartnerType = BUSPARTNER.BusinessPartnerType
                                                                    and bptypetext.Language            = 'E'

    left outer join I_SupplierCompany              as sup_com       on  sup_com.Supplier    = BUSPARTNER.BusinessPartner
                                                                    and sup_com.CompanyCode = JE.CompanyCode

{

  key JE.CompanyCode,
  key JE.FiscalYear,
  key JE.AccountingDocument,
  key Item.AccountingDocumentItem,

      // From Item_2 (Non-tax line)
      Item_3.Supplier,
      BUSPARTNER.BusinessPartnerName,

      // From Journal Entry
      JE.Branch,
      JE.DocumentReferenceID,
      JE.AccountingDocumentHeaderText,

      // From Item (Tax line)
      Item.GLAccount                     as TaxLedgerNo,
      glacc.GLAccountLongName            as TaxLedgerName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Tax Amt'
      Item.AmountInCompanyCodeCurrency   as TaxAmount,
      Item.CompanyCodeCurrency,
      Item.AssignmentReference           as AssignmentReference,
      Item.BusinessPlace                 as BusinessPlace,
      BUSPLACE.BusinessPlaceDescription  as BusinessPlaceDescription,
      JE.AccountingDocumentCreationDate  as DocumentDate,
      JE.DocumentDate                    as invoicedate1,
      JE.AccountingDocumentType          as VoucherType,
      Item.OriginalReferenceDocument     as ReferenceDoc,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Tax Base Amt'
      Item.OriginalTaxBaseAmtInAddlCrcy1 as TaxBaseAmount,
      Item.PostingDate                   as PostingDate,
      Item.TaxCode                       as TaxCode,
      _TaxCode.TaxCodeName               as TaxCodeName,

      // From Item_2
      Item_2.BaseUnit                    as BuM,
      @EndUserText.label: 'GSTIN'
      gstin.BPTaxNumber                  as GSTIN,
      Item_2.IN_HSNOrSACCode             as HSN_SAC,
      @EndUserText.label: 'Document Item Text'
      Item_2.DocumentItemText            as ItemText,
      Item_2.Material                    as Material,
      Item_2.Plant                       as Plant,
      Item_2.Product                     as ProductNumber,
      mtext.ProductName                  as ProductName,
      Item_2.ProfitCenter,
      @Semantics.quantity.unitOfMeasure: 'BuM'
      Item_2.PurchaseOrderQty,
      Item_2.PurchasingDocument,
      Item_2.PurchasingDocumentItem,
      Item_2.PurchasingDocumentPriceUnit,
      @EndUserText.label: 'Legal Form'
      BUSPARTNER.LegalForm,
      @EndUserText.label: 'Legal Form Text'
      LegalFormtext.LegalFormDescription,
      @EndUserText.label: 'Business Partner Type'
      BUSPARTNER.BusinessPartnerType,
      @EndUserText.label: 'Business Partner Type Dec.'
      bptypetext.BusinessPartnerTypeDesc,
      @EndUserText.label: 'Minority Group'
      sup_com.MinorityGroup

}
where
  (
    (
      (
           Item.CompanyCode                =  '3000'
        or Item.CompanyCode                =  '5000'
      )
      and  Item.AccountingDocumentItemType <> 'T'
    )
    or(
      (
           Item.CompanyCode                <> '3000'
        and Item.CompanyCode                <> '5000'
      )
      and  Item.AccountingDocumentItemType =  'T'
    )
  )
  and(
           JE.TransactionCode              =  'MIRO'
    or     JE.TransactionCode              =  'FB05'
    or     JE.TransactionCode              =  'MR8M'
    or     JE.TransactionCode              =  'MIR4'
    or     JE.TransactionCode              =  'FB70'
    or     JE.TransactionCode              =  'FB60'
    or     JE.TransactionCode              =  'F110'
    or     JE.TransactionCode              =  'FB08'
    or     JE.TransactionCode              =  'FBCJ'
    or     JE.TransactionCode              =  'FB01'
  )
