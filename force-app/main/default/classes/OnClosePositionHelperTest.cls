@isTest
public class OnClosePositionHelperTest {
    @isTest
    public static void archivateJobAdvertisementsValidTest(){
        TestDataFactory.insertMockCustomSettings();
        List <Position__c> positions = TestDataFactory.createPositions(101);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        Test.startTest();
        String msg;
        try{
            OnClosePositionHelper.archivateJobAdvertisements(positions);
        }catch(Exception e){
			msg = e.getMessage();
        }
        System.assertEquals( 0 , ApexPages.getMessages().size() );
        System.assert( msg == null );
        System.assert( RestContext.request == null );
        Test.stopTest();
    }
    @isTest
    public static void archivateJobAdvertisementsInvalidTest(){
        TestDataFactory.insertMockCustomSettings();
        List <Position__c> positions = TestDataFactory.createPositions(101);
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