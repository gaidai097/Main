public class PositionCreatedEmailService {
	
    public static List<String> getRecrutersEmails(){        
        List <String> recrutersEmails ;        
        try{
            recrutersEmails = collectRecruitersEmails( getRecrutersRolesIds() );        
            return recrutersEmails;
        }catch(QueryException e){  
            System.debug('Recruters Emails are not retrieved. Query Issue: ' + e);
            return null;
        }        
    }
    
    public static List<Id> getRecrutersRolesIds(){
        List <Id> roleIds = new List <Id>();
        List <UserRole> roles = [SELECT Id FROM UserRole WHERE name LIKE '%Recruiter%' OR name LIKE '%Recruiting Manager%'];
        for(UserRole role: roles){
            roleIds.add(role.Id);
        }
        return roleIds;
    }
    
    public static List<String> collectRecruitersEmails( List <Id> roleIds ){
		List <String> recrutersEmails = new List<String>();      
        for (User recruterUser : [SELECT Email FROM User WHERE UserRoleId IN :roleIds ]){            
            recrutersEmails.add(recruterUser.email);
        }
        return recrutersEmails;		
    }
    
    public static Messaging.SingleEmailMessage createEmailAfterPositionCreation( Position__c p , List <String> recrutersEmails ,EmailTemplate et){
        if( p == null || recrutersEmails == null || recrutersEmails.isEmpty()) return null;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        mail.setSubject('param1' + p.id); 
        mail.setToAddresses(recrutersEmails);
        mail.setTemplateId(et.id);
        mail.setTargetObjectId(p.CreatedById);
        mail.setHtmlBody(' id ' + p.id );
        mail.setSaveAsActivity(false);
        return mail;
    }
    public static Messaging.SendEmailResult[] sendEmail(List <Messaging.SingleEmailMessage>  mails  ){
        System.debug('sendEmail size : ' + mails.size());
        Messaging.SendEmailResult [] r = Messaging.sendEmail( mails ) ;
        for(Messaging.SendEmailResult res: r){
            if(!res.isSuccess()){
                System.debug('Email Issue: ' + res.getErrors());
            }
        }
        return r;     
    }  
}