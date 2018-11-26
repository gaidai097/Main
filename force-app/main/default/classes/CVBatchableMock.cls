@isTest
global class CVBatchableMock implements HttpCalloutMock {
    
    global  HTTPResponse respond(HTTPRequest req){
        if(req.getMethod() == 'POST' && req.getEndpoint() == 'https://login.salesforce.com/services/oauth2/token'){            
            return mockingOAuth();
        }
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?start=true')){            
            return mockingGetCount();
        }      
        if(req.getMethod() == 'GET' && req.getEndpoint().contains('/services/apexrest/newCVs?offset=' )  ){
            return mockingGetCVsValid();
        }
        
        return null;
    }
    public HTTPResponse mockingOAuth() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('{"access_token":"testToken","instance_url":"testUrl","signature":"test signature", "issued_at":"testissued_at","id":"testId"}');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingGetCount() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody('25');
        res.setStatusCode(200);
        return res;
    }
    public HTTPResponse mockingGetCVsValid() {
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept', 'application/json');
        res.setBody(

            '[{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0ddddd134dd@gmail.com","cvId":"a031t000276peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"ddddd134dd@gmail.com","cvId":"a031t000019eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"ddddd134dd@gmail.com","cvId":"a031t000060peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"1ddddd134dd@gmail.com","cvId":"a031t008276peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000044NSTFAA4","a021t000024NSTFAA4","a021t000034NSTFAA4"],"email":"12ddd134dd@gmail.com","cvId":"a031t000067eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"dd12dd134dd@gmail.com","cvId":"a031t000366peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0dddd12d4dd@gmail.com","cvId":"a031t000096peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"ddddsd12d4dd@gmail.com","cvId":"a031t000097eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"ddasdd4dd@gmail.com","cvId":"a031t000156peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0d134134dd@gmail.com","cvId":"a031t000777peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"ddd994dd@gmail.com","cvId":"a031t000877eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"dd888d134dd@gmail.com","cvId":"a031t000476peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0ddd0909dd@gmail.com","cvId":"a031t000070peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"ddddd578dd@gmail.com","cvId":"a031t000417eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"ddd34334dd@gmail.com","cvId":"a031t000426peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"023423134dd@gmail.com","cvId":"a031t000216peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"d1111d134dd@gmail.com","cvId":"a031t000337eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"dddd444d@gmail.com","cvId":"a031t000336peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"ddd777774dd@gmail.com","cvId":"a031t000365peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0d56555d134dd@gmail.com","cvId":"a031t000316peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"dd33333d134dd@gmail.com","cvId":"a031t000307eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"dd66666dd@gmail.com","cvId":"a031t000305peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Employeed","salary":740,"phone":"085400044444","name":"Sts Dfsss","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4"],"email":"0d36778134dd@gmail.com","cvId":"a031t000303peuSAAQ","contentVersionId":"06823t000000gqwIAAQ","age":33,"additionalInfo":null},{"status":"Unemployeed","salary":1250,"phone":"0504512327","name":"John Dou","jobs":["a021t000004NSTFAA4","a021t000014NSTFAA4","a021t000034NSTFAA4"],"email":"ddd4544dd@gmail.com","cvId":"a031t000302eahaAAA","contentVersionId":"0681t000000griQAAQ","age":20,"additionalInfo":null},{"status":"Employeed","salary":335,"phone":"085454544444","name":"Sts Dfsss","jobs":["a021t000024NSTFAA4","a021t000044NSTFAA4"],"email":"dddrtyuwd@gmail.com","cvId":"a031t000301peuSAAQ","contentVersionId":"0681t980000gqwIAAQ","age":33,"additionalInfo":null}]'

            
        );
        res.setStatusCode(200);
        return res;
    }
   
    
}