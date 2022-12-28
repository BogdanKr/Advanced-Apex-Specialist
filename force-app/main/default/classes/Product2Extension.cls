public class Product2Extension {

//    private final Product2 product;
    public List<ProductWrapper> productsToInsert { get; set; }

    public Product2Extension(ApexPages.StandardController stdController) {
//        this.product = (Product2) stdController.getRecord();
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void addRows() {
        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            productsToInsert.add(new ProductWrapper(new Product2(), new PricebookEntry()));
        }
    }

    public List<ChartHelper.ChartData> getInventory() {
        return ChartHelper.GetInventory();
    }

    public PageReference save() {
        Savepoint sp = Database.setSavepoint();
        try {
            List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
            List<Product2> product2s = new List<Product2>();
            for (ProductWrapper pw : productsToInsert) {
                if (pw.productRecord.Name != null
                        && pw.productRecord.Family  != null
                        && pw.productRecord.Family  != Constants.SELECT_ONE && pw.productRecord.IsActive != false
                        && pw.productRecord.Initial_Inventory__c != null && pw.pricebookEntryRecord.UnitPrice != null) {
//                    pw.pricebookEntryRecord.Product2 = pw.productRecord;
                    pw.pricebookEntryRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pw.pricebookEntryRecord.IsActive = true;
                    pricebookEntries.add(pw.pricebookEntryRecord);
                    product2s.add(pw.productRecord);
                }
            }
            insert product2s;
            for (Integer i = 0; i < pricebookEntries.size(); i++) {
                pricebookEntries[i].Product2Id = product2s[i].Id;
            }
            insert pricebookEntries;
            //If successful clear the list and display an informational message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, productsToInsert.size() + ' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e) {
            System.debug('Error debug =>'  +e.getMessage() + '\n Stack trace => '  + e.getStackTraceString());
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public List<SelectOption> getFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry pl : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(pl.value, pl.label));
        }
        return options;
    }

    public class ProductWrapper {
        public Product2 productRecord { get; set; }
        public PricebookEntry pricebookEntryRecord { get; set; }
        ProductWrapper(Product2 productRecord, PricebookEntry pricebookEntryRecord) {
            this.productRecord = productRecord;
            this.pricebookEntryRecord = pricebookEntryRecord;
        }


    }

}