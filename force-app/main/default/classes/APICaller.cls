public with sharing class APICaller {
    
    public OAuth2 oauth {get;set;} 
    
    public void oauthLogin(){   
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
            throw new Task6Exception('CalloutException during Authentication ');
        }catch(JSONException e){
            System.debug('JSONException during Authentication ' + e.getMessage());
            throw new Task6Exception('JSONException during Authentication ');
        }
    }
    public PageListWrapper getAllJobAdvertisements(Map <String, String> params) {
        
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        String endPoint = oauth.instance_url+'/services/apexrest/AllJobAdvertisements?page_limit='
                        + params.get('page_limit') + '&page_offset=' + params.get('page_offset');
        if( params.get('name') != null  &&  params.get('name') != '') endPoint += '&name=' + params.get('name');
        if( params.get('salary_filter') != null && params.get('salary_param') != null){
            endPoint += '&salary_filter=' + params.get('salary_filter');
            endPoint += '&salary_param=' + params.get('salary_param'); 
        }
        req.setEndpoint(endPoint);
        System.debug('endPoint : ' + endPoint );               
        req.setHeader('Authorization', 'OAuth ' + oauth.access_token);
        try{
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            switch on res.getStatusCode(){
                when 200 { return  (PageListWrapper) JSON.deserialize(res.getBody() , PageListWrapper.class); }
            	when 500 { throw new Task6Exception( res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException during request ' + e.getMessage());
            throw new Task6Exception('CalloutException during request ');
        }catch(JSONException e){
            System.debug('JSONException during request ' + e.getMessage());
            throw new Task6Exception('JSONException during request');
        } 
    }
    public void archivateJobAdvertisement(String jsonIDs){
        
        HttpRequest req = new HttpRequest();
        req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(oauth.instance_url+'/services/apexrest/archivateJobAdvertisement');
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);
        Http http = new Http();
        try {
            req.setBody( jsonIDs);
            HTTPResponse res = http.send(req);
            // StatusCode = 200 => successfully archived
            switch on res.getStatusCode(){
                when 200 {
                    if(res.getBody() == 'success'){
                        return;
                	}else{
                        throw new Task6Exception( 'Wrong response body');
                    }
                }
            	when 500 { throw new Task6Exception( 'when 500 ' + res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException e : ' + e);
            throw new Task6Exception('CalloutException during request ');
        }
    }    
    public JobAdvertisementsWrapper getJobAdvertisementById(String id){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept','application/json');
        req.setEndpoint(oauth.instance_url+'/services/apexrest/JobAdvertisementRecord?id='+ id);
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);
        try{
            Http http = new Http();
            HTTPResponse res = http.send(req);
            switch on res.getStatusCode(){
                when 200 { return  (JobAdvertisementsWrapper) JSON.deserialize(res.getBody() , JobAdvertisementsWrapper.class);}
            	when 500 { throw new Task6Exception( res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException during request ' + e.getMessage());
            throw new Task6Exception('CalloutException during request ');
        }catch(JSONException e){
            System.debug('JSONException during request ' + e.getMessage());
            throw new Task6Exception('JSONException during request');
        }
    }
    public void deleteJobAdvertisementById(String id){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');
        req.setHeader('Accept','application/json');
        req.setEndpoint(oauth.instance_url+'/services/apexrest/JobAdvertisementRecord?id='+ id);
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            // StatusCode = 200 => successfully deleted
            switch on res.getStatusCode(){
                when 200 {
                    System.debug('122 line ^^^ : ' +res.getBody() );
                    if(res.getBody() == 'success'){
                        return;
                	}else{
                        throw new Task6Exception( 'Wrong response body');
                    }
                }
            	when 500 { throw new Task6Exception( res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }            
        }catch(CalloutException e){
            System.debug('CalloutException e : ' + e);
            throw new Task6Exception('CalloutException during request ');
        }
    }    
    public String createJobAdvertisement( JobAdvertisementsWrapper obj ){
       
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');        
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(oauth.instance_url+'/services/apexrest/JobAdvertisementRecord');        
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);   
        try{
            req.setBody( JSON.serialize(obj));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            switch on res.getStatusCode(){
                when 200 { 
                    // return JobAdvertisement id
                    return  res.getBody();
                }
            	when 500 { throw new Task6Exception( res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException during request ' + e.getMessage());
            throw new Task6Exception('CalloutException during request ');
        }
    }
    public void updateJobAdvertisement(JobAdvertisementsWrapper obj){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');        
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(oauth.instance_url+'/services/apexrest/JobAdvertisementRecord');
        req.setHeader( 'Authorization', 'OAuth ' + oauth.access_token);     
        Http http = new Http();
        try{
            req.setBody( JSON.serialize(obj));
            HTTPResponse res = http.send(req);            
            switch on res.getStatusCode(){
                when 200 {
                    if(res.getBody() == 'success'){
                        return;
                	}else{
                        throw new Task6Exception( 'Wrong response body');
                    }
                }
            	when 500 { throw new Task6Exception( res.getBody());}
                when else { throw new Task6Exception('Exception , response status : ' + res.getStatusCode());}
            }
        }catch(CalloutException e){
            System.debug('CalloutException e : ' + e);
            throw new Task6Exception('CalloutException during request');
        }
    }
}