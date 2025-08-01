@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consu. view for Purchase Reg'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_GSTTAX_PURCHASE_REG
  provider contract transactional_query
  as projection on ZI_GSTTAX_PURCHASE_REG
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
      Supplier,
      BusinessPartnerName,
      Branch,
      DocumentReferenceID,
      AccountingDocumentHeaderText,
      TaxLedgerNo,
      TaxLedgerName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Tax Amt'
      TaxAmount,
      CompanyCodeCurrency,
      AssignmentReference,
      BusinessPlace,
      BusinessPlaceDescription,
      DocumentDate,
      invoicedate1,
      VoucherType,
      ReferenceDoc,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Tax Base Amt'
      TaxBaseAmount,
      PostingDate,
      TaxCode,
      TaxCodeName,
      BuM,
      @EndUserText.label: 'GSTIN'
      GSTIN,
      HSN_SAC,
      @EndUserText.label: 'Document Item Text'
      ItemText,
      Material,
      Plant,
      ProductNumber,
      ProductName,
      ProfitCenter,
      @Semantics.quantity.unitOfMeasure: 'BuM'
      PurchaseOrderQty,
      PurchasingDocument,
      PurchasingDocumentItem,
      PurchasingDocumentPriceUnit,
      @EndUserText.label: 'Legal Form'
      LegalForm,
      @EndUserText.label: 'Legal Form Text'
      LegalFormDescription,
      @EndUserText.label: 'Business Partner Type'
      BusinessPartnerType,
      @EndUserText.label: 'Business Partner Type Dec.'
      BusinessPartnerTypeDesc,
      @EndUserText.label: 'Minority Group'
      MinorityGroup
}
