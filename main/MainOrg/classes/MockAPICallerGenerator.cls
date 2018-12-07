@isTest
global class MockAPICallerGenerator implements HttpCalloutMock {
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
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('/services/apexrest/archivateJobAdvertisement')){            
            return mockingArchivateJobAdvertisement();
        }
        if(req.getMethod() == 'DELETE' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord?id=')){            
            return mockingDeleteJobAdvertisementById();
        }
        if(req.getMethod() == 'POST' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord')){            
            return mockingCreateJobAdvertisement();
        }        
        if(req.getMethod() == 'PUT' && req.getEndpoint().contains('/services/apexrest/JobAdvertisementRecord')){            
            return mockingUpdateJobAdvertisement();
        }		
        return null;
    }
    public HTTPResponse mockingOAuth() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingAllJobAdvertisements() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{"count" : "9", "jobAdvertisements" : [{"status":"Active","skills":"Java","salary":71717171,"phone":"01111111111","name":"Dancer","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ev1ZAAQ","email":"email@gmail.com","education":null,"description":null},{"status":"Active","skills":"MS Excel","salary":null,"phone":null,"name":"sometest1","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ez67AAA","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"AutoCAD;3DMax","salary":180,"phone":null,"name":"Egineer","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ev1UAAQ","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"Java;AutoCAD;3DMax","salary":2500,"phone":null,"name":"Barmen","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ev1KAAQ","email":"email@gmail.com","education":"High","description":null},{"status":"On hold","skills":"Photoshop","salary":1800,"phone":null,"name":"Officiant","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ev1PAAQ","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"MS Excel","salary":789,"phone":"09898989","name":"createJobAdvertisement88","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ezyvAAA","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"MS Excel","salary":1568,"phone":"0548454784","name":"createJob132784","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003f038AAA","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"MS Excel","salary":789,"phone":"09898989","name":"createJobAdvertisement5","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ezyqAAA","email":"email@gmail.com","education":"High","description":null},{"status":"Active","skills":"MS Excel","salary":null,"phone":null,"name":"checkedRecord1","manager_name":null,"longitude":null,"latitude":null,"id":"a021t000003ez68AAA","email":"email@gmail.com","education":"High","description":null}]}');  
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingJobAdvertisementById() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{"status":"Active","skills":"Java","salary":71717171,"phone":"01111111111","name":"Dancer","manager_name":null,"longitude":null,"latitude":null,"id":"a021t00000TestID","email":"email@gmail.com","education":null,"description":null}');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingDeleteJobAdvertisementById() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');        
        res.setStatusCode(200);
        res.setBody('success');   
        return res;
    }
    public HTTPResponse mockingCreateJobAdvertisement() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('a097t000000it1TEST');
 		res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingUpdateJobAdvertisement() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');        
 		res.setStatusCode(200);
        res.setBody('success');   
        return res;
    }
    public HTTPResponse mockingArchivateJobAdvertisement() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
		res.setBody('success');        
 		res.setStatusCode(200);
        return res;
    }
}