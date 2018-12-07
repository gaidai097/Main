public with sharing  class CVApiCaller {

    public OAuth2 oauth {get;set;} 
    
    public void oauthLogin(){
       this.oauth = OAuth2.login();
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
                when 401 { 
                    System.debug('401 Retry auth');
                    throw new Task6Exception( 'Retry auth');
                }
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