@isTest
global class CVFlexibleBehaviorMock implements HttpCalloutMock {
     /*
     * 
     * 
     * 
     */
    global Integer index = 0;
    global  HTTPResponse respond(HTTPRequest req){
        System.debug('HTTPResponse' + ' index ' + index);
        System.debug( req.getMethod()  + ' ' + req.getEndpoint());
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
            return mockingOAuth();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?start=true')){            
            return mockingGetCount();
        }      
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 0 +'&limit='+ 2 ) && index == 0 ){  
            this.index++;
            return mockingInvalidAuthToken();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 0 +'&limit='+ 2 ) && index == 1){  
            this.index++;
            return mockingGetFirstCVsValid();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 2 +'&limit='+ 2 ) && index == 2){  
            this.index++;
            return mockingInvalidJSONToken();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 2 +'&limit='+ 2) && (index > 3 )){  
            this.index++;
            return mockingGetCVsValid();
        } 
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 4 +'&limit='+ 2  ) && (index >= 3)){  
            this.index++;
            return mockingInvalidJSONToken();
        } 
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 6 +'&limit='+ 2  ) ){  
            this.index++;
            return mockingInvalidAuthToken();
        } 
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' + 6 +'&limit='+ 2  ) && (index >= 5)){  
            this.index++;
            return mockingInvalidJSONToken();
        }
        return null;
    }
    public HTTPResponse mockingOAuth() {
        System.debug('mockingOAuth' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingGetCount() {
        System.debug('mockingGetCount' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('7');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingGetFirstCVsValid() {
        System.debug('mockingGetFirstCVsValid' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('[{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NkdtAAC","a021t000005u3WnAAI"],"email":"0ddddd134dd@gmail.com","cvId":"a031t002206peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NkdtAAC","a021t000005u3WnAAI","a021t000003gEywAAE"],"email":"ddddd134dd@gmail.com","cvId":"a031t000007eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null}]'
                   );
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingInvalidAuthToken() {
        System.debug('mockingInvalidAuthToken' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('Invalid TEST body' );
        res.setStatusCode(401);
        return res;
    }
    public HTTPResponse mockingInvalidJSONToken() {
        System.debug('mockingInvalidJSONToken' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('["Invalid TEST body" : "test"]' );
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingGetCVsValid() {
        System.debug('mockingGetCVsValid' + ' index ' + index);
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody(
            '[{"status":"Employeed","salary":33'+getRandomInteger()+',"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000003gCp3AAE"],"email":"0d'+getRandomInteger()+getRandomInteger()+getRandomInteger()+getRandomInteger()+'dd134dd@gmail.com","cvId":"a031t0000'+getRandomInteger()+getRandomInteger()+'peuSAAQ","contentVersionId":"0681t'+getRandomInteger()+getRandomInteger()+'0000gqwIAAQ","age":33,"additionalInfo":null}]'
                   );
        res.setStatusCode(200);
        return res;
    }
    public Integer getRandomInteger(){
        Integer random = TestDataFactory.generateRandomFromRange(0, 9);
        return random;
    }
    
}