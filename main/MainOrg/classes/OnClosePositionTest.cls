@isTest
public class OnClosePositionTest {
	@isTest
    public static void onCloseUpdatePositionValidTest(){
        TestDataFactory.insertMockCustomSettings();
        List <Position__c> positions = TestDataFactory.createPositions(101);
        for(Position__c position: positions ){
            position.status__c = 'Closed' ;
        }
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        Test.startTest();
        String msg;
        update positions;
        System.assertEquals( 0 , ApexPages.getMessages().size() );
        Test.stopTest();
    }
    @isTest
    public static void onCloseDeletePositionValidTest(){
        TestDataFactory.insertMockCustomSettings();
        List <Job_Application__c> jobs = TestDataFactory.createJobApplications(101);        
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        Test.startTest();
        List <Position__c > positions = [SELECT ID FROM Position__c];
        String msg;
        delete positions;
        positions = [SELECT ID FROM Position__c];
        jobs = [SELECT ID FROM Job_Application__c];
        List<CVSnapshot__c> cvs = [SELECT ID FROM CVSnapshot__c];
        Test.stopTest();
        System.assertEquals( 0 , positions.size() );
        System.assertEquals( 0 , jobs.size() );
        System.assertEquals( 0 , cvs.size() );
         
    }
    @isTest
    public static void archivateJobAdvertisementsInvalidTest(){
        TestDataFactory.insertMockCustomSettings();
        List <Position__c> positions = TestDataFactory.createPositions(101);
        for(Position__c position: positions ){
            position.status__c = 'Closed' ;
        }
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());        
        Test.startTest();
        String msg;
        try{
            OnClosePositionHelper.archivateJobAdvertisements(positions);
        }catch(Exception e){
			msg = e.getMessage();            
        }
        System.assert( msg == null );
        Test.stopTest();       
    }
}