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
    
    //  что если позишн закрыли, а сервер не смог заархивить обьявление
}