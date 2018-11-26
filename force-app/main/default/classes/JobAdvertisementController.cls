public class JobAdvertisementController {
    public APICaller api {get;set;}
    public boolean connected {get;set;}
    public JobAdvertisementsWrapper currentJA {get;set;}
    public Position__c position {get;set;}
    
    public JobAdvertisementController(){
        ID currentRecordId =  ApexPages.currentPage().getParameters().get('id');
        fetchPosition(currentRecordId);
    }
    public void fetchPosition(ID positionID){
        try{
            this.position = [SELECT ID, External__c, Education__c, Hiring_Manager__c,
                             Hiring_Manager__r.Phone, Job_Description__c, Publication_Status__c,
                             Hiring_Manager__r.Email , Hiring_Manager__r.Name,Salary_Range__c,
                             Name , Status__c, Location__c , Approval_Status__c,Skills_Required__c
                            FROM Position__c WHERE id=:positionID LIMIT 1];    
        }catch(QueryException e){
            sendError(System.Label.PositionFetchingException + ' ' + e);
        }
    }
    public void postAdvertisement(){
        api = new APICaller();
        login();
        JobAdvertisementsWrapper wrappedPosition = JobAdvertisementsWrapper.convertPosition(position);        
        String externalId = createJobAdvertisement(wrappedPosition);
        if(externalId != null ){
            position.External__c = externalId ;
            position.Publication_Status__c = 'Posted';
            update position;
            sendInfo(System.Label.Position_successfully_posted);
        }
    }
    public void updateAdvertisement(){
        api = new APICaller();
        login();
        fetchPosition(position.id);
        JobAdvertisementsWrapper wrappedPosition = JobAdvertisementsWrapper.convertPosition(position);
        updateJobAdvertisement(wrappedPosition);
    }
    public void removeAdvertisement(){
        api = new APICaller();
        login();
        deleteJobAdvertisementById(position.External__c);
    }
    public void login(){
        try{
        	api.oauthLogin();
        	connected = api.oauth != null ? true : false ;
        }catch(Task6Exception e){
            System.debug('Task6Exception e : ' + e);
            sendError('Connection failed');
            connected = false;
        }
    }
    public void deleteJobAdvertisementById(String externalId){
        try{
            api.deleteJobAdvertisementById( externalId ) ;
            sendInfo('Deleted Successfully');
            if(position.External__c != null ){
                position.External__c = null ;
                position.Publication_Status__c = 'Not posted';
                update position;
            }
        }catch(Task6Exception e){
            System.debug('Task6Exception e : ' + e.getMessage());
            sendError(e.getMessage());
        }
    }
    public String createJobAdvertisement(JobAdvertisementsWrapper wrappedPosition){
        try{
            return api.createJobAdvertisement(wrappedPosition) ;
        }catch(Task6Exception e){
            System.debug('Task6Exception e : ' + e.getMessage());
            sendError(e.getMessage());
            return null;
        }
        
    }
    public void updateJobAdvertisement(JobAdvertisementsWrapper wrappedPosition){
        String resultMsg;
        try{
            api.updateJobAdvertisement(wrappedPosition) ;
            System.debug(System.Label.JobAdveirtesement_successfully_updated);
            sendInfo(System.Label.JobAdveirtesement_successfully_updated);
        }catch(Task6Exception e){
            System.debug('Task6Exception e : ' + e.getMessage());
            sendError(e.getMessage());
        }        
    }
    public void sendError(String msg){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
    }
    public void sendInfo(String msg){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, msg));
    }
    
    
    public void getJobAdvertisementById(String checkedRecord){
        api = new APICaller();
        login();
        try{
            this.currentJA = api.getJobAdvertisementById(checkedRecord) ; 
            sendInfo('Selected successfully');
        }catch(Task6Exception e){
            System.debug('Task6Exception e : ' + e.getMessage());
            sendError(System.Label.Server_Exception);
        }             
    }
    
}