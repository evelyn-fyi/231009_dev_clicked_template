public with sharing class BillEmailer {
    
    public static void sendEmails(Map<String, Blob> emailsWithBills) {
        //instantiate a list of Messaging.SingleEmailMessage objects

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        //iterate over the keyset of the emailsWithBills map and instantiate a single Messaging.SingleEmailMessage
        //object. Set the bccAddress to the email from the iteration, set a PlainTextBody, and use the following
        //to attach the PDF blob to the email:
        //
        // Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        // attach.Body = emailsWithBills.get(email);
        // attach.FileName = 'Bill-' + Date.Today().day() + '-' + Date.Today().Month() + '-' + Date.Today().Year();
        // attach.ContentType = 'application/pdf';
        // mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        //
        //add the Messaging.SingleEmailMessage object to the list inside of the loop, and send the email outside of the loop.

        for(String email : emailsWithBills.keySet()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setBccAddresses(new String[]{email});
            mail.setPlainTextBody('Please see attached for your most recent bill.');


            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.Body = emailsWithBills.get(email);
            attach.FileName = 'Bill-' + Date.Today().day() + '-' + Date.Today().Month() + '-' + Date.Today().Year();
            attach.ContentType = 'application/pdf';

            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});

            emailsToSend.add(mail);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsToSend);
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }

    //this is a method that will allow you to check to see if your code works.
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
}