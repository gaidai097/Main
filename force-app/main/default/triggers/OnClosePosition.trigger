trigger OnClosePosition on Position__c (after update) {
    List <Position__c> positions = new List <Position__c>();
    for( Position__c position : Trigger.New ){
        if( Trigger.OldMap.get(position.Id).Status__c != position.Status__c 
            && position.Status__c == 'Closed' && position.Publication_Status__c =='Posted' 
            && position.External__c != null){
            positions.add(position);
        }
    }
    if(positions.size() > 0){ 
        OnClosePositionHelper.archivateJobAdvertisements(positions);
    }
}