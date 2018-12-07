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
        Messaging.SendEmailResult [] results = Messaging.sendEmail( mails ) ;
        for(Messaging.SendEmailResult res: results){
            if(!res.isSuccess()){
                System.debug('Email Issue: ' + res.getErrors());
            }
        }
        return results;        
    }
    public static void sendEmailToAdmins( String msg ){
        try{
            List <String> adminAdresses = getAdminsEmails();
            Messaging.SingleEmailMessage mail = formEmailToAdmins(msg, adminAdresses);       
            sendEmail(new List <Messaging.SingleEmailMessage>{mail});
        }catch(Exception e){
            System.debug('Email was not sent succesfully ! ' + e.getTypeName() + '  ' + e.getMessage() + '  ' + e.getStackTraceString());
        }
    }
    public static List <String> getAdminsEmails(){
        Profile sys_adm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List <User> sys_adm = [SELECT id, Email FROM User WHERE ProfileId = :sys_adm_profile.id];
        List <String> adminAdresses = new List <String>();
        for(User admin: sys_adm){
            adminAdresses.add( admin.Email );
        }
        return adminAdresses;
    }
    public static Messaging.SingleEmailMessage formEmailToAdmins(String msg, List <String> adminAdresses ){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();              
        mail.setPlainTextBody(msg);
        mail.setBccSender(false);        
        mail.setUseSignature(false);       
        mail.setSaveAsActivity(false);   
        mail.setBccAddresses(adminAdresses); 
        return mail;
    }
}