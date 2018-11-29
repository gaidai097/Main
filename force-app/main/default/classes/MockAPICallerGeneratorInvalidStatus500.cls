@isTest
global class MockAPICallerGeneratorInvalidStatus500  implements HttpCalloutMock {
 // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
            return mockingOAuth();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/AllJobAdvertisements')){            
            return mockForAcceptHeader();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord?id=')){            
            return mockForAcceptHeader();
        }
        if(req.getMethod() == 'DELETE' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord?id=')){            
            return mockForAcceptHeader();
        }
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('/services/apexrest/archivateJobAdvertisement')){            
            return mockForContentHeader();
        }
        if((req.getMethod() == 'PUT' || req.getMethod() == 'POST' ) && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord')){            
            return mockForContentHeader();
        }
        if( req.getEndpoint().contains('/services/apexrest/newCVs') ){            
            return mockForAcceptHeader();
        }
        return null;
    }
    public HTTPResponse mockingOAuth(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
  
    public HTTPResponse mockForAcceptHeader() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody(System.Label.Server_Exception);
        res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockForContentHeader() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
		res.setBody(System.Label.Server_Exception);        
 		res.setStatusCode(500);
        return res;
    }
}