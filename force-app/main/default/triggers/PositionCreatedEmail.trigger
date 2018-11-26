trigger PositionCreatedEmail on Position__c (after insert) {
    
    List <String> recrutersEmails = PositionCreatedEmailService.getRecrutersEmails();  
    List <Messaging.SingleEmailMessage> mails = new List <Messaging.SingleEmailMessage>();
    EmailTemplate et = [select id, name from EmailTemplate where name = 'ForPosition'];
    
    if( recrutersEmails != null && !recrutersEmails.isEmpty() ){
        for(Position__c p : Trigger.New){        
            mails.add( PositionCreatedEmailService.createEmailAfterPositionCreation( p, recrutersEmails , et) );            
        }
    }
    System.debug('mails ' + mails);
    PositionCreatedEmailService.sendEmail(mails);
}