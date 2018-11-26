trigger ReassignUnclaimedPositionToQueue on Position__c (before insert) {
    try{    
        Id unclaimedPositionQueueId = [SELECT  QueueId FROM QueueSObject where Queue.Name = 'Unclaimed Positions Queue' LIMIT 1].QueueId;   
        if( unclaimedPositionQueueId != null){
            LIst <ID> recrutersIds = ReassignUnclaimedPositionToQueueService.getRecrutersIds();
            for( Position__c position : Trigger.New ){
                if(  recrutersIds == null || !recrutersIds.contains(position.ownerId)  ){              
                    position.ownerId = unclaimedPositionQueueId;                
                }
            } 
        }
    }catch(Exception e){
        System.debug ('OwnerIds were not updated');
    }
  
	
}