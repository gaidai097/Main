@isTest
public class CVJobTest {
	//@isTest
    public static void invalidAuthTest(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidJSONAuth());
        Test.startTest();
        CVJob.calloutSize= 2;
        CVJob.executions = 2;
        CVJob.batchSize = 4;
        CVJob job = new CVJob();
        job.fetchCVs();
        Test.stopTest();
    }
   // @isTest
    public static void fetchCVsValidTest(){
        TestDataFactory.insertMockCustomSettings();
        
        List <Position__c> positions = TestDataFactory.createPositions(5);
        positions[0].External__c = 'a021t000004NSTFAA4';
        positions[1].External__c = 'a021t000003gCp3AAE';
        positions[2].External__c = 'a021t000004NkdtAAC';
        positions[3].External__c = 'a021t000005u3WnAAI';
        positions[4].External__c = 'a021t000003gEywAAE';
        update positions;
        List <Candidate__c> candidates = TestDataFactory.createCandidates(1);
        candidates[0].Email__c = 'ddddd134dd@gmail.com';
        update candidates;
        Test.setMock(HttpCalloutMock.class, new CVFlexibleBehaviorMock());
        
        Test.startTest();
        CVJob.calloutSize= 2;
        CVJob.executions = 2;
        CVJob.batchSize = 4;
        CVJob job = new CVJob();
        job.fetchCVs();                
        Test.stopTest();
        List <Job_Application__c> jobApplications = [Select ID from Job_Application__c];
        List <CVSnapshot__c> cvSnapshots = [Select ID from CVSnapshot__c];
        candidates = [Select ID from Candidate__c];
        System.assertEquals( 2, candidates.size() );
        System.assertEquals( 5, jobApplications.size() );
        System.assertEquals( 2, cvSnapshots.size() );
    }
    
    //@isTest
    public static void calculateOffsetsTest(){
        
        CVJob.calloutSize= 2;
        CVJob.executions = 2;
        CVJob.batchSize = 4;
        List < List<Integer> > offsets = CVJob.calculateOffsets(8);
       	System.assertEquals( 2,  offsets.size());
        System.assertEquals( new List<Integer>{4, 6},  offsets.get( offsets.size() - 1));
        
        offsets = CVJob.calculateOffsets(1);
       	System.assertEquals( 1,  offsets.size());
        System.assertEquals( new List<Integer>{0},  offsets.get( offsets.size() - 1));
        
        offsets = CVJob.calculateOffsets(9);
       	System.assertEquals( 3,  offsets.size());
        System.assertEquals( new List<Integer>{8},  offsets.get( offsets.size() - 1));
        
    }
    @isTest
    public static void cvScheduledTest(){
        TestDataFactory.insertMockCustomSettings();
        
        List <Position__c> positions = TestDataFactory.createPositions(5);
        positions[0].External__c = 'a021t000004NSTFAA4';
        positions[1].External__c = 'a021t000003gCp3AAE';
        positions[2].External__c = 'a021t000004NkdtAAC';
        positions[3].External__c = 'a021t000005u3WnAAI';
        positions[4].External__c = 'a021t000003gEywAAE';
        update positions;
        List <Candidate__c> candidates = TestDataFactory.createCandidates(1);
        candidates[0].Email__c = 'ddddd134dd@gmail.com';
        update candidates;
        Test.setMock(HttpCalloutMock.class, new CVFlexibleBehaviorMock());
        
        Test.startTest();
        CVJob.calloutSize= 2;
        CVJob.executions = 2;
        CVJob.batchSize = 4;
        CVScheduled job = new CVScheduled();
        job.execute(null);
        //System.schedule('TestJob', cronExp, job);              
        Test.stopTest();
        List <Job_Application__c> jobApplications = [Select ID from Job_Application__c];
        List <CVSnapshot__c> cvSnapshots = [Select ID from CVSnapshot__c];
        candidates = [Select ID from Candidate__c];
        System.assertEquals( 2, candidates.size() );
        System.assertEquals( 5, jobApplications.size() );
        System.assertEquals( 2, cvSnapshots.size() );
    }
}