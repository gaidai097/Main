@isTest
public class CVApiCallerTest {
	@isTest
    public static void APICallerInalidStatus500Test(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        Test.startTest();
        CVApiCaller api = new CVApiCaller();
        api.oauthLogin();
        String msg ;
        msg = null;
        try{ api.fetchCVsCount();}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        try{ api.fetchCVs(2, 2);}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains(System.Label.Server_Exception));
        Test.stopTest();
    }
 	@isTest
    public static void APICallerInalidCalloutTest(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidCallOut());
        Test.startTest();
        CVApiCaller api = new CVApiCaller();
        api.oauthLogin();
        String msg ;
        msg = null;
        try{ api.fetchCVsCount();}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        try{ api.fetchCVs(2, 2);}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('CalloutException during request'));
        Test.stopTest();
    }
    @isTest
    public static void Status401Test(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockStatus401());
        Test.startTest();
        CVApiCaller api = new CVApiCaller();
        api.oauthLogin();
        String msg ;
        msg = null;
        try{ api.fetchCVsCount();}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('Retry'));
        msg = null;
        try{ api.fetchCVs(2, 2);}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('Retry'));
        Test.stopTest();
    }
    @isTest
    public static void Status300Test(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockStatus300());
        Test.startTest();
        CVApiCaller api = new CVApiCaller();
        api.oauthLogin();
        String msg ;
        msg = null;
        try{ api.fetchCVsCount();}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('Exception , response status : 300'));
        msg = null;
        try{ api.fetchCVs(2, 2);}catch(Task6Exception e){
            msg = e.getMessage();
        }      
        System.assert(msg.contains('Exception , response status : 300'));
        Test.stopTest();
    }
    
    
    public class MockStatus401  implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
                return mockingOAuth();
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
            res.setStatusCode(401);
            return res;
        }
    }
    public class MockStatus300  implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
                return mockingOAuth();
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
            res.setStatusCode(300);
            return res;
        }
        
        public HTTPResponse mockForAcceptHeader() {
            HttpResponse res = new HttpResponse();
            res.setHeader('Accept','application/json');
            res.setBody('Exception ');
            res.setStatusCode(300);
            return res;
        }
    }
    
    
}