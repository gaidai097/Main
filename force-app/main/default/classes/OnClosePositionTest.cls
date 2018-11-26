@isTest
public class OnClosePositionTest {
	@isTest
    public static void onClosePositionValidTest(){
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
        //System.assert( msg == null );
        Test.stopTest();        
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