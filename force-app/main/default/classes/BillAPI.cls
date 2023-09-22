public with sharing class BillAPI {
    
    public static List<BillWrapper> getBillWrappers() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Billing_API');
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response = http.send(req);
        String responseBody = response.getBody();

        List<BillWrapper> bwList = (List<BillWrapper>)JSON.deserialize(responseBody, List<BillWrapper>.class);

        return bwList;
    }

    public class BillWrapper {
        public String billId;
        public String accountName;
        public String balance;
    }
}