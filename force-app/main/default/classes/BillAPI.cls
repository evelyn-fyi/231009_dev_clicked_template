public with sharing class BillAPI {
    
    public static List<Bill__c> getBills() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Billing_API');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String responseBody = response.getBody();

        List<BillWrapper> bwList = (List<BillWrapper>)JSON.deserialize(responseBody, List<BillWrapper>.class);

        List<Bill__c> billsToInsert = new List<Bill__c>();

        List<Account> activeAccounts = [SELECT Id, Name FROM Account WHERE Active__c = 'Yes'];

        Map<String, Id> activeAccountMap = new Map<String, Id>();

        for(Account act : activeAccounts) {
            activeAccountMap.put(act.Name, act.Id);
        }

        for(BillWrapper bw : bwList) {
            Bill__c billToInsert = new Bill__c();
            billToInsert.Bill_Id__c = bw.billId;
            billToInsert.Account__c = activeAccountMap.get(bw.accountName);
            billToInsert.Balance__c = Decimal.valueOf(bw.balance.replace('$', ''));

            billsToInsert.add(billToInsert);
        }

        insert billsToInsert;

        List<Bill__c> insertedBills = [SELECT Id FROM Bill__c WHERE Id IN :billsToInsert];

        return insertedBills;
    }

    public class BillWrapper {
        public String billId;
        public String accountName;
        public String balance;
    }
}