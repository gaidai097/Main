@isTest
global class MockAPICallerGeneratorInvalidStatus500  implements HttpCalloutMock {
 // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
            return mockingOAuth();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/AllJobAdvertisements')){            
            return mockingAllJobAdvertisements();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord?id=')){            
            return mockingJobAdvertisementById();
        }
        if(req.getMethod() == 'DELETE' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord?id=')){            
            return mockingDeleteJobAdvertisementById();
        }
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('/services/apexrest/archivateJobAdvertisement')){            
            return mockingArchivateJobAdvertisement();
        }
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord')){            
            return mockingCreateJobAdvertisement();
        }
        if(req.getMethod() == 'PUT' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord')){            
            return mockingUpdateJobAdvertisement();
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
    public HTTPResponse mockingAllJobAdvertisements() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody(System.Label.Server_Exception);
        res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockingJobAdvertisementById() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody(System.Label.Server_Exception);
        res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockingArchivateJobAdvertisement(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(System.Label.Server_Exception);
 		res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockingDeleteJobAdvertisementById() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody(System.Label.Server_Exception);
        res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockingCreateJobAdvertisement() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(System.Label.Server_Exception);
 		res.setStatusCode(500);
        return res;
    }
    public HTTPResponse mockingUpdateJobAdvertisement() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
		res.setBody(System.Label.Server_Exception);        
 		res.setStatusCode(500);
        return res;
    }
}