@IsTest
private class OrderTests {
    @TestSetup
    private static void setupTestData() {
        TestDataFactory.InsertTestData(1);
        insert TestDataFactory.ConstructCollaborationGroup();
    }

    @IsTest
    private static void orderUpdate_UnitTest() {
        List<Order> orders = [SELECT Id FROM Order];
        List<Product2> originalProduct = [SELECT Id, Quantity_Ordered__c FROM Product2];
        for (Order o : orders) {
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        update orders;
        List<Product2> updatedProduct = [SELECT Id, Quantity_Ordered__c FROM Product2];

        TestDataFactory.VerifyQuantityOrdered(originalProduct.get(0), updatedProduct.get(0), Constants.DEFAULT_ROWS);
    }

    @IsTest
    private static void OrderExtension_UnitTest() {
        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);
        Order o = [SELECT Id, Status FROM Order LIMIT 1];
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(o);
        OrderExtension ext = new OrderExtension(stdcontroller);
        System.assertEquals(1, ext.orderItemList.size());
        ext.OnFieldChange();
        ext.SelectFamily();
        ext.Save();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
        ext.GetFamilyOptions();
    }

}