@isTest
global class MockAPICallerGeneratorInvalidJSONAuth implements HttpCalloutMock {
    global Integer index = 0;
    global  HTTPResponse respond(HTTPRequest req){
        this.index++;
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token' && index < 3){  
            return mockingInvalidOAuth();
        }else{
            return mockingValidOAuth();
        }
    }
    public HTTPResponse mockingInvalidOAuth() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{ccess_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(401);
        return res;
    }
    public HTTPResponse mockingValidOAuth() {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
}