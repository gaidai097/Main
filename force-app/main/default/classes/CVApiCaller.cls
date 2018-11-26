public with sharing  class CVApiCaller {

    public OAuth2 oauth {get;set;} 
    
    public void oauthLogin(){
        
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
            this.oauth = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
        }catch(CalloutException e){
            System.debug('CalloutException during Authentication ' + e.getMessage());
            throw new Task6Exception('Retry auth');
        }catch(JSONException e){
            System.debug('JSONException during Authentication ' + e.getMessage());
            throw new Task6Exception('Retry auth');
        }
    }
    public Integer fetchCVsCount(){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        req.setEndpoint( oauth.instance_url + '/services/apexrest/newCVs?start=true' );
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);
        try{
            Http http = new Http();
            HTTPResponse res = http.send(req);
            switch on res.getStatusCode(){
                when 200 { return Integer.valueOf( res.getBody() ) ;}
            	when 500 { throw new Task6Exception( res.getBody());}                
                when else { System.debug('error: ' + res.getBody()); throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException during request ' + e.getMessage());
            throw new Task6Exception('CalloutException during request ');
        }    
    }
    public String fetchCVs( Integer offset, Integer limitSize){
        
        HttpRequest req = new HttpRequest();
        req.setMethod( 'GET' );
        req.setHeader( 'Accept', 'application/json' );
        req.setEndpoint( oauth.instance_url + '/services/apexrest/newCVs?offset=' + offset +'&limit='+limitSize );
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);
        try{
            Http http = new Http();
            HTTPResponse res = http.send(req);
            switch on res.getStatusCode(){
                when 200 { return res.getBody(); }
                when 401 { 
                    System.debug('401 Retry auth');
                    throw new Task6Exception( 'Retry auth');
                }
            	when 500 { System.debug('error: '+ res.getStatusCode() + ' ' + res.getBody()); throw new Task6Exception( res.getBody());}
                when else { System.debug('error: '+ res.getStatusCode() + ' ' + res.getBody()); throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException during request ' + e.getMessage());
            throw new Task6Exception('CalloutException during request ');
        }    
    }
}