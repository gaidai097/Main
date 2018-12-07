@isTest
global class MockInvalidCallOutAuth implements HttpCalloutMock {
    global  HTTPResponse respond(HTTPRequest req){
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        throw e;        
    }
}