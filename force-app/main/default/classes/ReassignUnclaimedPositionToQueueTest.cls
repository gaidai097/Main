@isTest
public class ReassignUnclaimedPositionToQueueTest {
    @isTest 
    public static void ReassignUnclaimedPositionValidOwnerNotRecruiterTest(){
        
        TestDataFactory.createUnclaimedPositions(1);        
        Id expectedId = ReassignUnclaimedPositionToQueueService.getUnclaimedPositionQueueId();
        Id actual = [Select OwnerId from Position__c][0].OwnerId ;
        
        System.assertEquals(expectedId, actual);
        
    }
    @isTest
    public static void ReassignUnclaimedPositionOwnerRecruiterTest(){
        TestDataFactory.createPositionsWithRecruiterOwner(1);                
        Id ownerId = [Select OwnerId from Position__c][0].OwnerId ;
     	// Check that Owner ID was not changed and belongs to Recruiters
        System.assertEquals(true, ReassignUnclaimedPositionToQueueService.getRecrutersIds().contains(ownerId));
    }
    @isTest
    public static void ReassignUnclaimedPositionValidOwnerNotRecruiterBulkTest(){
        TestDataFactory.createUnclaimedPositions(20);        
        Id expectedId = ReassignUnclaimedPositionToQueueService.getUnclaimedPositionQueueId();
        
        for(Position__c p : [Select OwnerId from Position__c]){
            System.assertEquals(expectedId, p.OwnerId);
        }
        
        
    }
    @isTest
    public static void ReassignUnclaimedPositionOwnerRecruiterBulkTest(){
        TestDataFactory.createPositionsWithRecruiterOwner(20);                
        Id ownerId = [Select OwnerId from Position__c][15].OwnerId ;
        // Check that Owner ID was not changed and belongs to Recruiters
        List<Id> recruitersIds = ReassignUnclaimedPositionToQueueService.getRecrutersIds();
        Id actual = [Select OwnerId from Position__c][19].OwnerId ;
        for(Position__c p : [Select OwnerId from Position__c]){                        
            System.assertEquals(true, recruitersIds.contains(p.OwnerId)); 
        }
    }
     
}