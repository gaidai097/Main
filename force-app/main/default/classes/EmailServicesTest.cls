@isTest
public class EmailServicesTest {
    
    public static String adminEmail = EmailServices.getAdminsEmails()[0];
    public static EmailTemplate et= [Select id, Body, Subject from EmailTemplate where Name=:'ForTasks'];
    public static String company = 'CompanyTest';
    public static String lastname = 'LeadNameTest' ;
    
	@isTest
    public static  void EmailServicesOneValidDataTest() {              
      
        Task task = new Task(Subject = 'TestSubject', 
                             Status = 'Not Started', 
                             OwnerId = UserInfo.getUserId()
                            );
    
        Test.startTest(); 
        Messaging.SingleEmailMessage mail =  EmailServices.createEmailAfterConversion(            
            new Task(Subject = 'TestSubject', Status = 'Not Started', OwnerId = UserInfo.getUserId()),
            adminEmail,
            et
        );
        List<Messaging.SingleEmailMessage> mails = new List <Messaging.SingleEmailMessage> ();  
        mails.add(mail);
       	Messaging.SendEmailResult[] r = EmailServices.sendEmail(mails);
                       
        Test.stopTest();
        System.assertEquals (1, r.size()); 
        System.assertEquals (true, r[0].IsSuccess()); 
    }
    @isTest
    public static  void EmailServicesOneInvalidDataTest() {
      
        Test.startTest();
        Messaging.SingleEmailMessage mail =  EmailServices.createEmailAfterConversion(
            null,
            adminEmail,
            et
        );
        Messaging.SendEmailResult[] r;       
        Boolean result = false;
        try{
            List<Messaging.SingleEmailMessage> mails = new List <Messaging.SingleEmailMessage> ();  
            mails.add(mail);
            r = EmailServices.sendEmail(mails);
            
        }catch(Exception e){
            result = true;
        }     
        Test.stopTest();
        System.assertEquals(true, result);
        System.assertEquals(null, r);
    }
    @isTest
    public static  void EmailServicesManyValidDataTest() {
        
        List<Messaging.SingleEmailMessage> mails = new List <Messaging.SingleEmailMessage> ();            
        for (Integer i = 0; i < 101; i++){          
            mails.add( EmailServices.createEmailAfterConversion(
                    new Task(Subject = 'TestSubject' + i, 
                        Status = 'Not Started', 
                        OwnerId = UserInfo.getUserId()
                    ),
                    adminEmail,
                    et
                )
            );            
        }
        Test.startTest();
        Messaging.SendEmailResult[] r ;
        Boolean result = true;
        try{            
            r = EmailServices.sendEmail(mails);            
        }catch(Exception e){
            result = false;
        }     
        Test.stopTest();
        System.assertEquals(true, result); 
        for(Messaging.SendEmailResult rs: r){
            System.assertEquals(true, rs.IsSuccess()); 
        }
    }
    @isTest
    public static void sendEmailToAdminsValidTest(){
        Test.startTest();
        EmailServices.sendEmailToAdmins('TestMSG');
        System.assertEquals( 1 , Limits.getEmailInvocations() ); 
        Test.stopTest();
    }
    @isTest
    public static void sendEmailToAdminsInvalidTest(){
        Test.startTest();
        EmailServices.sendEmailToAdmins(null);
        System.assertEquals( 0, Limits.getEmailInvocations() ); 
        Test.stopTest();
    }
    
}