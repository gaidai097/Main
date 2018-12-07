@isTest
public class CVBatchableTest {
	@isTest
    public static void invalidAuthTest(){
        System.debug('----------invalidAuthTest()');
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidJSONAuth());
        Test.startTest();
        CVJob.calloutSize= 2;
        CVJob.callouts = 2;
        CVJob.batchSize = 4;
        CVJob job = new CVJob();
        job.count = 3;
        CVBatchable batch = new CVBatchable( job.calculateOffsets() , new OAuth2() , 2, false); 
        database.executebatch( batch, 1 );
        
        Test.stopTest();
    }
 	@isTest
    public static void fetchCVsValidTest(){
        System.debug('----------fetchCVsValidTest()');
        TestDataFactory.insertMockCustomSettings();
        Integer count = 5;
        List <Position__c> positions = TestDataFactory.createPositions(5);
        for( Integer i = 0; i<5; i++ ){
            positions[i].External__c = 'a021t0000' +i +'4NSTFAA4';
        }
        update positions;
        List <Candidate__c> candidates = TestDataFactory.createCandidates(1);
        candidates[0].Email__c = 'ddddd134dd@gmail.com';
        update candidates;
        Test.setMock(HttpCalloutMock.class, new CVBatchableMock());
        
        Test.startTest();
        CVJob job = new CVJob();
        job.fetchCVs();                
        Test.stopTest();
        List <Job_Application__c> jobApplications = [Select ID from Job_Application__c];
        List <CVSnapshot__c> cvSnapshots = [Select ID from CVSnapshot__c];
        candidates = [Select ID from Candidate__c];
        System.assertEquals( 24, candidates.size() );
        System.assertEquals( 58, jobApplications.size() );
        System.assertEquals( 25, cvSnapshots.size() );
    }
    @isTest
    public static void unsuccessfulRetryFinishTest(){
     
        Test.startTest();
        CVJob job = new CVJob();
        job.count = 100;
        CVBatchable batch = new CVBatchable( job.calculateOffsets() , new OAuth2() , 4, true);
        batch.offsetsToRetry =  job.calculateOffsets();
        batch.finish(null);
        System.assertEquals( 1, Limits.getEmailInvocations() ); 
        Test.stopTest();
        
    }
}