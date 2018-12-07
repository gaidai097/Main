global class EmailServices  {
    // Additional class for Task1
    
    public static Messaging.SingleEmailMessage createEmailAfterConversion( Task task, String adminAdresse, EmailTemplate et  ){
        if( task == null || adminAdresse == null){
            return null;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();              
        mail.setTemplateId(et.Id);    
        mail.setBccSender(false);        
   		mail.setUseSignature(false);       
        mail.setTargetObjectId(task.OwnerId);
        mail.setSaveAsActivity(false);   
        mail.setBccAddresses(new String[]{adminAdresse});
        
        return mail;
    }
      public static Messaging.SendEmailResult[] sendEmail(List <Messaging.SingleEmailMessage>  mails  ){
        System.debug('Emails : ' +mails.size() );
        Messaging.SendEmailResult [] r = Messaging.sendEmail( mails ) ;
        for(Messaging.SendEmailResult res: r){
            if(!res.isSuccess()){
                System.debug('Email Issue: ' + res.getErrors());
            }
        }
        return r;
     
    }
}