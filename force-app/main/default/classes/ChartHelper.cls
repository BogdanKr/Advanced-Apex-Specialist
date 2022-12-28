public without sharing class ChartHelper {

    @AuraEnabled
    public static List<ChartData> GetInventory() {
        List<ChartData> cht = new List<ChartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        AggregateResult[] groupedResults = [
                SELECT Family, SUM(Quantity_Remaining__c) Quantity
                FROM Product2 WHERE IsActive = TRUE
                GROUP BY Family
        ];
        for (AggregateResult ar : groupedResults) {
            System.debug('Family -' + ar.get('Family'));
            System.debug('Quantity -' + ar.get('Quantity'));
            cht.add(new ChartData((String)ar.get('Family'), (Decimal)ar.get('Quantity')));
        }

        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        return cht;
    }

    public class ChartData {
        public String name { get; set; }
        public Decimal val { get; set; }

        public ChartData(String name, Decimal val) {
            this.name = name;
            this.val = val;
        }
    }

}