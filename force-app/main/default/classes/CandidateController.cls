public with sharing class CandidateController {
    public Blob image {get;set;}
    public Id contentId {get;set;}    
    public boolean isOwner {get;set;}
    public Candidate__c candidate {get;set;}    
    public ContentDocumentLink contentDocumentLink {get;set;}
    
	public CandidateController() {
        ID currentRecordId =  ApexPages.currentPage().getParameters().get('id');
        fetchCandidate(currentRecordId); 
        if(candidate != null || candidate.id != null){
            checkOwner();        
            fetchContent(currentRecordId); 
        }else{
            sendError('Error, There aren\'t any candidate with current iD ' + currentRecordId);
        }               
    }
    public void fetchCandidate(ID paramId){
        try{
            this.candidate = [SELECT ID, First_Name__c, Education__c,OwnerId, Currently_Employed__c,
                            Last_Name__c,Mobile__c, Years_of_Experience__c, Email__c 
                            FROM Candidate__c WHERE id=:paramId LIMIT 1];    
        }catch(Exception e){ sendError('Error during Candidate fetching ' + e);}          
    }
    public void checkOwner(){
        isOwner =  candidate.OwnerId == UserInfo.getUserId() ?  true : false ;
    }
    public void fetchContent(ID paramId){
        List<ContentDocumentLink> contentDocumentLinks ;
        try{
            contentDocumentLinks = [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersionId 
                                    FROM ContentDocumentLink
                                    WHERE LinkedEntityId =:paramId LIMIT 1];  
        }catch(Exception e){
            sendError('Exception during ContentDocumentLink fetching ' + e);
            contentDocumentLinks = null;
        }
        if( contentDocumentLinks != null && contentDocumentLinks.size() > 0 ){
            fetchContentVersion(contentDocumentLinks[0]);
        }else{ 
            this.contentId = null;
            this.contentDocumentLink = null;
        }   
    } 
    public void fetchContentVersion(ContentDocumentLink cdl){
        this.contentId = cdl.ContentDocument.LatestPublishedVersionId;
        this.contentDocumentLink = cdl;
        try{
            ContentVersion cv  = [SELECT VersionData FROM ContentVersion WHERE id=:contentId LIMIT 1 ][0];
            this.image = cv.VersionData;
        }catch(Exception e){
            sendError('Exception during ContentVersion fetching ' + e);
        }
    }     
    public PageReference upload() {
        if(image.size() > 1048576){
        sendError('File is too big! Select a file less than 1Mb');
            this.image = null;
            return null;
        }
        ContentVersion cv = createContentVersion();
        saveContentVersion(cv);
        return null;
    }
    public ContentVersion createContentVersion(){
        ContentVersion cv = new ContentVersion(Description = 'avatar', OwnerId = UserInfo.getUserId(),
            VersionData = image, title = 'avatar', PathOnClient  = 'avatar'
        );
        if(contentDocumentLink == null){
            this.contentDocumentLink = new ContentDocumentLink(LinkedEntityId = candidate.Id, ShareType = 'I');  			        
        }else{
            cv.ContentDocumentId = contentDocumentLink.ContentDocumentId;            
        }
        return cv;
    } 
    public boolean saveContentVersion(ContentVersion cv){
        try {
            insert cv;
            contentId = cv.id;
            if(contentDocumentLink.id == null){
                contentDocumentLink.ContentDocumentId = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =:contentId LIMIT 1][0].id;
                insert contentDocumentLink ;
            }
        }catch (Exception e) {
            System.debug('Exception uploading e ' + e);
            sendError('Error , content is not uploaded '+ e);
            return false;
        }
        sendInfo('Content uploaded successfully');
        return true;
    }
    public PageReference deleteUploadedImage(){
        try {
            delete [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =:contentId LIMIT 1];
        } catch (Exception e) {
            System.debug('Exception delete e ' + e);
            sendError('Error, ContentDocument is not deleted ' + e);
            return null;
        }
        sendInfo('Image deleted successfully ');
        image = null;
        contentDocumentLink = null;
        contentId = null;
        return null;
    }
    public void sendError(String msg){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
    }
    public void sendInfo(String msg){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, msg));
    }
}