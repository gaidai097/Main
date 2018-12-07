@isTest
public class PositionCreatedEmailTest {
	@isTest
    public static void PositionCreatedEmailOneTest(){
        Integer count = 1;
        Test.startTest();
        TestDataFactory.createPositions(count);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest(); 
        System.assertEquals( count, [Select Id from Position__c].size() );        
      	System.assertEquals(count, invocations, 'no email sent');
    }
    @isTest
    public static void PositionCreatedEmailManyTest(){
        Integer count = 101;
        Test.startTest();        
        TestDataFactory.createUnclaimedPositions(count);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();     
      	System.assertEquals( count, [Select Id from Position__c].size() );   
        // Just 1 invocation for 101 emails, List as parameter
      	System.assertEquals(1, invocations, 'no email sent');
    }
}