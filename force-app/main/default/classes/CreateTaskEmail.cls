global class CreateTaskEmail  implements Messaging.InboundEmailHandler {
    // Task 2
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        if( !email.subject.contains('Need Help')){
            return null;
        }
        // IF Body is empty ??????
        try {
            List <User> users = [SELECT Id FROM User WHERE Alias = 'SupportU'] ; 
            if(users == null || users.size()==0 ){
                result.success = false;
                return result;
            }
            User supportUser = users[0];
            Id caseId = saveCase(email, supportUser.Id);            
            if(email.binaryAttachments != null && email.binaryAttachments.size() >0){
                saveAttachments(email , caseId);                
            }                                  
            result.success = true;
        } catch (QueryException e) {
           System.debug('Query Issue: ' + e);
           result.success = false;
        } catch (Exception e) {
           System.debug('Unexpected problem: ' + e);
           result.success = false;
        } 
        return result;  
    }
    public Id saveCase(Messaging.InboundEmail email, ID ownerId ){        
        String stringifiedDate = System.now().format('yyyy-MM-dd/HH:mm:ss');
        String subject = email.subject + '_' + email.fromAddress + '_' + stringifiedDate ;
        Case newCase = new Case(Subject = subject,
                                Type = 'Email Support', 
                                Email_Body__c = email.plainTextBody,                                   
                                OwnerId = ownerId ,
                                Status = 'New',
                                Origin = 'Email');       
        insert newCase; 
        
        return newCase.Id ;
    }
    public void saveAttachments(Messaging.InboundEmail email, ID parentId){
        for( Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments ) {
            if( bAttachment.body.size()> 1024*1024) continue;                   
            Attachment attachment = new Attachment();                
            attachment.ParentId = parentId;
            attachment.description = 'fromEmail';
            attachment.Name = bAttachment.filename;
            attachment.Body = bAttachment.body;
            insert attachment;
        } 
    }
}