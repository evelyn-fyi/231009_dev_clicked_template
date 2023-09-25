public with sharing class BillBatch implements Database.Batchable<sObject> {
    
    public List<Account> receivesBillByEmail;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        //this is a method that will query for all accounts that are active (Account.Active__c = TRUE)
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        //this is a method that will process the queried for records, call the method of the API class
        //to grab new bills, match the new bills with the existing accounts, insert a new bill that
        //is associated with the account (whether they receive their bill by email or not), and prepare
        //a list of accounts (receivesBillByEmail) to carry over to the finish method.
    }

    public void finish(Database.BatchableContext bc){
        //this is the final method of the class, that will be called after all processing in the
        //start and execute methods is complete. We will use this method to send an email to each
        //customer in the receivesBillByEmail list.
    }
}