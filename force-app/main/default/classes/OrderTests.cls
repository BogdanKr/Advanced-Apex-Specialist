@IsTest
private class OrderTests {
    @TestSetup
    public static void setupTestData() {
        TestDataFactory.InsertTestData(1);
    }

    @IsTest
    public static void orderUpdate_UnitTest(){
        List<Order> orders = [SELECT Id FROM Order];
        List<Product2> originalProduct = [SELECT Id, Quantity_Ordered__c FROM Product2];
        for (Order o: orders){
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        update orders;
        List<Product2> updatedProduct = [SELECT Id, Quantity_Ordered__c FROM Product2];

        TestDataFactory.VerifyQuantityOrdered(originalProduct.get(0), updatedProduct.get(0), Constants.DEFAULT_ROWS);
    }
}