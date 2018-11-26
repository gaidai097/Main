trigger JobApplicationUpdate on Job_Application__c (after update) {
    
    List <Task> tasks = new List <Task>();    
    for( Job_Application__c jobApl : Trigger.New ){  
        if( Trigger.OldMap.get(jobApl.Id).Status__c != jobApl.Status__c && jobApl.Status__c == 'Rejected' ){
            tasks.add( JobApplicationUpdateService.createTask(jobApl , 'Send Rejection Letter') );
        }
        if( Trigger.OldMap.get(jobApl.Id).Status__c != jobApl.Status__c && jobApl.Status__c == 'Extend an Offer' ){
            tasks.add( JobApplicationUpdateService.createTask(jobApl, 'Extend an Offer') );
        }
    }
    JobApplicationUpdateService.insertTasks(tasks);
}