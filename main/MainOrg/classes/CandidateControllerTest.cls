@isTest
public class CandidateControllerTest {
    @isTest
    public static void CandidateControllerValidTest(){
        Candidate__c candidate = TestDataFactory.createCandidates(1)[0];
        ApexPages.currentPage().getParameters().put('id',candidate.id);
        CandidateController cc = new CandidateController();
        // create blob, compare size after executing methods
        Blob image = Blob.valueOf('a'.repeat(120));
        cc.image = image;
        cc.upload();
        ContentVersion cv = [SELECT VersionData,OwnerId, ContentSize FROM ContentVersion][0];        
        System.assertEquals(image.size(), cv.ContentSize);
        System.assertEquals(UserInfo.getUserId(), cv.OwnerId);
        //Remove image in the next session
        cc  = new CandidateController();
        System.assertEquals(image.size(), cc.image.size());
        cc.deleteUploadedImage();
        List <ContentVersion> cvs = [SELECT VersionData,OwnerId, ContentSize FROM ContentVersion];
        cc  = new CandidateController();
        System.assertEquals( null, cc.image);
        System.assertEquals( 0, cvs.size());
    }
    @isTest
    public static void CandidateControllerInvalidTest(){
        Candidate__c candidate = TestDataFactory.createCandidates(1)[0]; 
        ApexPages.currentPage().getParameters().put('id', candidate.id);
        CandidateController cc = new CandidateController();
        // Create too big Blob file
        cc.image = Blob.valueOf('a'.repeat(1242880));
        cc.upload();
        System.assertEquals(null, cc.image);
        System.assertEquals('File is too big! Select a file less than 1Mb', ApexPages.getMessages()[0].getSummary());
        
        cc.contentId = null ;
        cc.fetchCandidate(null);
        System.assert( ApexPages.getMessages()[1].getSummary().contains('Error during Candidate fetching'));
        
        cc.fetchContent(null);
        System.assert( ApexPages.getMessages()[2].getSummary().contains('Exception during ContentDocumentLink fetching'));
        
        ContentDocument cd = new ContentDocument( );
        cc.fetchContentVersion(new ContentDocumentLink( ContentDocument = cd));        
        System.assert( ApexPages.getMessages()[3].getSummary().contains('Exception during ContentVersion fetching'));
        
        cc.saveContentVersion(null);
        System.assert( ApexPages.getMessages()[4].getSummary().contains('Error , content is not uploaded'));

        System.assertEquals(ApexPages.Severity.ERROR , ApexPages.getMessages()[0].getSeverity() );
        System.assertEquals(5 , ApexPages.getMessages().size() );
    }
    
}