@isTest
global class MockAPICallerGeneratorInvalidCallOut implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
            return mockingOAuth();
        }else{
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
        	e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
       		throw e;
        }		
    }
    public HTTPResponse mockingOAuth() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
}