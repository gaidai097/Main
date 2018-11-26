@isTest
public class APICallerTest {
    @isTest
    public static void APICallerInalidStatus500Test(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        Test.startTest();
        APICaller api = new APICaller();
        api.oauthLogin();
        String msg ;
        try{
            PageListWrapper p = api.getAllJobAdvertisements(new Map <String, String> ()); 
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        try{ api.getJobAdvertisementById('a021t000003ev1ZAAQ');}catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        try{ api.deleteJobAdvertisementById('a021t000003ev1ZAAQ');}catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        JobAdvertisementsWrapper objForCreating = new JobAdvertisementsWrapper();
        objForCreating.salary = '12345';
        objForCreating.email = 'test@gmail.com';
        objForCreating.name = 'Test';
        try{ api.createJobAdvertisement(objForCreating); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        try{ api.updateJobAdvertisement(objForCreating); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        msg = null;
        try{ api.archivateJobAdvertisement('testID'); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains(System.Label.Server_Exception));
        Test.stopTest();
    }
    @isTest
    public static void APICallerInalidJSONTest(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidJSON());
        Test.startTest();
        APICaller api = new APICaller();
        api.oauthLogin();
        String msg ;
        try{
            PageListWrapper p = api.getAllJobAdvertisements(new Map <String, String> ());            
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('JSONException during request'));
        msg = null;
        try{
            api.getJobAdvertisementById('a021t000003ev1ZAAQ');
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('JSONException during request'));
        Test.stopTest();
    }
    
	@isTest
    public static void APICallerInalidAuthTest(){
        TestDataFactory.insertMockCustomSettings();
		Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidJSONAuth());
		Test.startTest();
        APICaller api = new APICaller();
        String msg ;
        try{ 
        	api.oauthLogin();
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        Test.stopTest();
        System.assert(msg.contains('JSONException during Authentication '));
		System.assert( api.oauth == null); 
		
    }
    @isTest
    public static void APICallerInvalidAuthCalloutTest(){
        TestDataFactory.insertMockCustomSettings();
		Test.setMock(HttpCalloutMock.class, new MockInvalidCallOutAuth());
		Test.startTest();
        APICaller api = new APICaller();
        String msg ;
        try{ 
        	api.oauthLogin();
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        Test.stopTest();
        System.assert(msg.contains('CalloutException during Authentication'));
		System.assert( api.oauth == null); 
		
    }
    @isTest
    public static void APICallerInalidCalloutTest(){
        TestDataFactory.insertMockCustomSettings();
		Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidCallOut());
		Test.startTest();
        APICaller api = new APICaller();
        api.oauthLogin();
        String msg ;
        try{ 
            PageListWrapper p = api.getAllJobAdvertisements(new Map <String, String> ()); 
        }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        try{ api.getJobAdvertisementById('a097t000000it1TEST'); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        try{ api.deleteJobAdvertisementById('a097t000000it1TEST'); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        JobAdvertisementsWrapper exampleObj = new JobAdvertisementsWrapper();
        exampleObj.salary = '12345';
        exampleObj.email = 'test@gmail.com';
        exampleObj.name = 'Test';
        try{ api.createJobAdvertisement(exampleObj); }catch(Task6Exception e){
            msg = e.getMessage();
        }
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        try{ api.updateJobAdvertisement(exampleObj); }catch(Task6Exception e){
            msg = e.getMessage();
        }        
        System.assert(msg.contains('CalloutException during request'));
        msg = null;
        try{ api.archivateJobAdvertisement('testID'); }catch(Task6Exception e){
            msg = e.getMessage();
        }        
        System.assert(msg.contains('CalloutException during request'));
        Test.stopTest();
		
    }
    @isTest
    public static void APICallerValidTest(){
        TestDataFactory.insertMockCustomSettings();
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        Test.startTest();
        APICaller api = new APICaller();
        String msg ;
        api.oauthLogin();
        PageListWrapper p = api.getAllJobAdvertisements(new Map <String, String> ()); 
        System.assertEquals( 9 , p.count);
        String testId = 'a021t00000TestID';   
        JobAdvertisementsWrapper resultObj = api.getJobAdvertisementById(testId);
        System.assertEquals( testId, resultObj.id);
        
		api.deleteJobAdvertisementById(testId);
        System.assertEquals( null , msg);
        JobAdvertisementsWrapper objForCreating = new JobAdvertisementsWrapper();
        objForCreating.salary = '12345';
        objForCreating.email = 'test@gmail.com';
        objForCreating.name = 'Test';
        msg = api.createJobAdvertisement(objForCreating);
        System.assertEquals( 'a097t000000it1TEST',msg );
        api.updateJobAdvertisement(objForCreating);
        api.archivateJobAdvertisement('a097t000000it1TEST');
        Test.stopTest();
        // messages List is empty when updating done successfull
        System.assertEquals( 0, ApexPages.getMessages().size() );
    }
}