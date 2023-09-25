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

    //this is what's known as a wrapper class. A wrapper class
    //allows us to create an instance of a class with the properties
    //we specify. In this case, we are creating a class that will hold
    //the properties for the BillId, AccountName, and Balance, which will
    //be populated from the JSON structure that is stored in our external
    //data source. Once we get the body of our HTTP callout, we will use
    //the following line of code to transform the response body (responseBody)
    //into a list of instances of our wrapper class, BillWrapper:
    //
    //List<BillWrapper> bwList = (List<BillWrapper>)JSON.deserialize(responseBody, List<BillWrapper>.class);
    //
    //once we have a list of BillWrapper objects (bwList), we will iterate over the
    //bwList, instantiate a new Bill__c object record, and assign the values of the
    //BillWrapper properties to the fields on the Bill__c record.
    
    public class BillWrapper {
        public String billId;
        public String accountName;
        public String balance;
    }
}