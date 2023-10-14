public with sharing class AccountController {
    public AccountController() {

        List<Account> accList = [SELECT Id, Name FROM Account Where Active = 'Yes'];

    }
}