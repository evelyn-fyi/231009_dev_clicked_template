public with sharing class BillAPI {
    
    public static void getBills() {
        //start by creating an HttpRequest object and set the endpoint and method.
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Billing_API');
        req.setMethod('GET');

        //set up an Http object and an HTTPResponse Object and use the .getBody() method here.
        Http http = new Http();
        HTTPResponse response = http.send(req);
        String responseBody = response.getBody();

        //Use the following to deserialize the JSON response into a wrapper class:
        List<BillWrapper> bwList = (List<BillWrapper>)JSON.deserialize(responseBody, List<BillWrapper>.class);

        //create a list of bills to insert
        List<Bill__c> billsToInsert = new List<Bill__c>();

        //query for active accounts (Active__c = 'Yes')
        List<Account> activeAccounts = [SELECT Id, Name FROM Account WHERE Active__c = 'Yes'];

        //create an active account map in the form of Map<String, Id>
        Map<String, Id> activeAccountMap = new Map<String, Id>();

        //iterate over the list of active accounts, and use the .put() method of the Map class
        // to insert the account name and Id as the key value pair.
        //https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_map.htm
        for(Account act : activeAccounts) {
            activeAccountMap.put(act.Name, act.Id);
        }

        //iterate over the list of BillWrappers, bwList, and create a new bill in each iteration.
        //Match the new bill fields with the properties of the BillWrapper class, using the following for
        //Bill__c.Balance:
        //billToInsert.Balance__c = Decimal.valueOf(bw.balance.replace('$', ''));
        //at the end of the for loop, add the newly created bill to a list of bills to insert
        //remember, DML should not go in for loops!
        for(BillWrapper bw : bwList) {
            Bill__c billToInsert = new Bill__c();
            billToInsert.Bill_Id__c = bw.billId;
            billToInsert.Account__c = activeAccountMap.get(bw.accountName);
            billToInsert.Balance__c = Decimal.valueOf(bw.balance.replace('$', ''));

            billsToInsert.add(billToInsert);
        }

        //finally, insert the new bills list
        insert billsToInsert;
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