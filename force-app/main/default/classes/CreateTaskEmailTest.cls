@isTest
public class CreateTaskEmailTest {
    
    public static String subject = 'Test Need Help Test';
    public static String contactEmail = 'contactEmail@test.com';
    public static User supportUser = [SELECT Id FROM User WHERE Alias = 'SupportU'] ;
    
    @isTest
    public static  void CreateTaskEmailValidTest() {        
        
        String plainTextBody = 'TestLineForBody' + System.now().Date();
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.plainTextBody = plainTextBody;
        email.fromAddress = contactEmail;
        email.ccAddresses = new String[]{};
        email.subject = subject;
        Messaging.Inboundemail.BinaryAttachment  att = new Messaging.Inboundemail.BinaryAttachment();
        att.body = Blob.valueOf('a'.repeat(60));
        att.filename = 'Unit Test Attachment';
        List <Messaging.Inboundemail.BinaryAttachment> attachments = 
            new List <Messaging.Inboundemail.BinaryAttachment>();
        attachments.add(att);
        email.binaryAttachments = attachments;
                      
        CreateTaskEmail edr = new CreateTaskEmail();
        
        Test.startTest();          
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        String descr = 'fromEmail' ;
        Case [] createdCase = [SELECT Id,
                               (SELECT Id, Name FROM Attachments Where description = :descr LIMIT 1 ),
                               Email_Body__c FROM Case WHERE subject LIKE 'Test Need Help Test%'];        
        Test.stopTest();        

        System.assertEquals (true, result.success); 
        System.assertEquals (plainTextBody, createdCase[0].Email_Body__c); 
        System.assertEquals (1, createdCase[0].attachments.size()); 
        System.assertEquals (1, createdCase.size(),'Case was not inserted');  
    }
    @isTest
    public static  void CreateTaskEmailUpdatedUserAliaseTest() {        
    
        String plainTextBody = 'TestLineForBody' + System.now().Date();
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
        email.plainTextBody = plainTextBody;
        email.fromAddress = contactEmail;
        email.ccAddresses = new String[]{};
        email.subject = subject;
        CreateTaskEmail edr = new CreateTaskEmail();
        
        Test.startTest();   
        supportUser.Alias = 'new';
        update supportUser;       
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Case [] createdCase = [SELECT Id FROM Case WHERE subject LIKE 'Test Need Help Test%'];        
        Test.stopTest();
        
        System.assertEquals (result.success, false); 
        System.assertEquals (0, createdCase.size(),'Exception was not Caught');  
    }
    @isTest
    public static void CreateTaskEmailWithInappropriateSubjectTest() {        
    
       
        String plainTextBody = 'TestLineForBody' + System.now().Date();
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.plainTextBody = plainTextBody;
        email.fromAddress = contactEmail;
        email.ccAddresses = new String[]{};
        email.subject = 'InappropriateSubject test';
                
        CreateTaskEmail edr = new CreateTaskEmail();
        
        Test.startTest();          
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Case [] createdCase = [SELECT Id FROM Case WHERE subject LIKE 'Test Need Help Test%'];        
        Test.stopTest();        

        System.assertEquals ( null, result); 
        System.assertEquals (0, createdCase.size(),'Case should not be inserted');  
    }
    @isTest
    public static  void CreateTaskEmailTooBigBlobTest() {        
        
        String plainTextBody = 'TestLineForBody' + System.now().Date();
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.plainTextBody = plainTextBody;
        email.fromAddress = contactEmail;
        email.ccAddresses = new String[]{};
        email.subject = subject;
        Messaging.Inboundemail.BinaryAttachment  att = new Messaging.Inboundemail.BinaryAttachment();
        att.body = Blob.valueOf('a'.repeat(1242880));                
        att.filename = 'Unit Test Attachment';
        List <Messaging.Inboundemail.BinaryAttachment> attachments = 
            new List <Messaging.Inboundemail.BinaryAttachment>();
        attachments.add(att);
        email.binaryAttachments = attachments;
                      
        CreateTaskEmail edr = new CreateTaskEmail();
        
        Test.startTest();          
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        String descr = 'fromEmail' ;
        Case [] createdCase = [SELECT Id,
                               (SELECT Id, Name FROM Attachments Where description = :descr LIMIT 1 ),
                               Email_Body__c FROM Case WHERE subject LIKE 'Test Need Help Test%'];        
        Test.stopTest();        

        System.assertEquals (0, createdCase[0].attachments.size());  
        System.assertEquals (1, createdCase.size());
    }
    @isTest
    public static  void CreateTaskEmailExceptionFromAttBodyTest() {        
        
        String plainTextBody = 'TestLineForBody' + System.now().Date();
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.plainTextBody = plainTextBody;
        email.fromAddress = contactEmail;
        email.ccAddresses = new String[]{};
        email.subject = subject;
        Messaging.Inboundemail.BinaryAttachment  att = new Messaging.Inboundemail.BinaryAttachment();
        att.body = null;                
        att.filename = null;
        List <Messaging.Inboundemail.BinaryAttachment> attachments = 
            new List <Messaging.Inboundemail.BinaryAttachment>();
        attachments.add(att);
        email.binaryAttachments = attachments;
                      
        CreateTaskEmail edr = new CreateTaskEmail();
        
        Test.startTest();          
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        String descr = 'fromEmail' ;
        Case [] createdCase = [SELECT Id,
                               (SELECT Id, Name FROM Attachments Where description = :descr LIMIT 1 ),
                               Email_Body__c FROM Case WHERE subject LIKE 'Test Need Help Test%'];        
        Test.stopTest();        

        System.assertEquals (false, result.success);
    }
     
}