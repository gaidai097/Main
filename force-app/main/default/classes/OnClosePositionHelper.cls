public with sharing class OnClosePositionHelper {
   
    public static void archivateJobAdvertisements(List <Position__c> positions){
       
        List <String> iDs = new List <String>();
        for(Position__c position: positions){
            iDs.add(position.External__c);
        }    
        sendPost(JSON.serialize(iDs));
    } 
    @future (callout=true)
    public static void sendPost(String iDs){
        APICaller api = new APICaller();        
        try{
           api.oauthLogin();
           api.archivateJobAdvertisement(iDs);
        }catch(Task6Exception e){
            System.debug('Task6Exception e' + e.getMessage());
        }
    }
    public static void clearCVs(List <Position__c> positions){
        try{
            Map <ID, Position__c> positionsMap = new Map< Id,Position__c>(positions);
            List <Job_Application__c> jobs = [Select ID, CVSnapshot__c FROM Job_Application__c WHERE Position__c IN : positionsMap.keySet()];
            List <ID> cvsIds = selectCVIds(jobs);
            // Delete JobApplications related to current Positions
            delete jobs;
            deleteCVSnapshots(cvsIds);
        }catch(Exception e){
            System.debug( e.getTypeName() + ' ' + e.getMessage() );
        }    
        
    }
    public static List <ID> selectCVIds(List <Job_Application__c> jobs){
        List <ID> cvsIds = new List <ID>();
        for(Job_Application__c job: jobs){
            cvsIds.add(job.CVSnapshot__c);
        }
        return cvsIds;
    }
    public static void deleteCVSnapshots(List <ID> cvsIds){
        // Delete CVSnapshots without any related Job_Application__c
        try{
            List <CVSnapshot__c> cvsToDelete = new List <CVSnapshot__c>();
            List <CVSnapshot__c> cvs = [Select ID, (SELECT ID from Job_Applications__r) FROM CVSnapshot__c WHERE ID IN :cvsIds ];
            for(CVSnapshot__c cv: cvs){
                if( cv.Job_Applications__r.isEmpty() || cv.Job_Applications__r == null){
                    cvsToDelete.add(cv);
                }
            }
            delete cvsToDelete;
        }catch(Exception e){
            throw new Task6Exception('CVSnapshots were not removed');
        }
    }
    
   
}