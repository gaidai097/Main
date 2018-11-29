public class OAuth2 {
    public String id{get;set;}
    public String issued_at{get;set;}
    public String instance_url{get;set;}
    public String signature{get;set;}
    public String access_token{get;set;}
    
    public static OAuth2 login(){
         //   401 with the following body : [{"message":"Session expired or invalid","errorCode":"INVALID_SESSION_ID"}]
        OAuth_integration__c settingsAPI = OAuth_integration__c.getOrgDefaults();
        
        String reqbody = 'grant_type=password&client_id=' + settingsAPI.clientId__c
                        +'&client_secret=' + settingsAPI.clientSecret__c
                        +'&username=' + EncodingUtil.urlEncode(settingsAPI.username__c, 'UTF-8')
                        +'&password=' + EncodingUtil.urlEncode(settingsAPI.password__c, 'UTF-8');
        System.debug(reqbody);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setHeader('Accept','application/json');        
        req.setMethod('POST');
        req.setEndpoint(settingsAPI.destURL__c);
        try{
            HttpResponse res = h.send(req);
            OAuth2 oauth = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
            return oauth;
        }catch(CalloutException e){
            System.debug('CalloutException during Authentication ' + e.getMessage());
            throw new Task6Exception('Retry auth');
        }catch(JSONException e){
            System.debug('JSONException during Authentication ' + e.getMessage());
            throw new Task6Exception('Retry auth');
        }
    }
}