@isTest
public class JobAdvertisementControllerTest {
    
    @isTest
    public static void JobAdvertisementControllerGetByIdInvalid500Test(){
        TestDataFactory.insertMockCustomSettings();
		Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.startTest();
		JobAdvertisementController controllerObj = new JobAdvertisementController();
        controllerObj.getJobAdvertisementById(position.id);
        Test.stopTest();
        System.assert(controllerObj.connected == true);
        System.assert( controllerObj.currentJA == null);
        System.assertEquals(System.Label.Server_Exception, ApexPages.getMessages()[0].getSummary() );
    }
    @isTest
    public static void JobAdvertisementControllerPostInalid500Test(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        controllerObj.postAdvertisement();
        position = [SELECT External__c, Publication_Status__c FROM Position__c where id =: position.id][0];
        System.assertNotEquals( null , position.External__c);
        Test.stopTest();
        System.assertEquals(System.Label.Server_Exception, ApexPages.getMessages()[0].getSummary() );
    }
    @isTest
    public static void JobAdvertisementControllerPutInvalid500Test(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        controllerObj.updateAdvertisement();
        position = [SELECT External__c, Publication_Status__c FROM Position__c where id =: position.id][0];
        Test.stopTest();
        System.assertNotEquals( null , position.External__c);
        System.assertEquals(System.Label.Server_Exception , ApexPages.getMessages()[0].getSummary() );
    }
    @isTest
    public static void controllerRemoveInvalid500Test(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidStatus500());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        // remove Advertisement for current object
        controllerObj.removeAdvertisement();
        position = [SELECT External__c, Publication_Status__c FROM Position__c where id =: position.id][0];
        System.assertEquals(System.Label.Server_Exception, ApexPages.getMessages()[0].getSummary() );
        System.assertEquals( 'Posted' , position.Publication_Status__c);
    }
	@isTest
    public static void JobAdvertisementControllerPostsValidTest(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);

        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        // publish Advertisement for current object 
		controllerObj.postAdvertisement();
        position = [SELECT External__c, Publication_Status__c FROM Position__c where id =: position.id][0];
        System.assertEquals( 'a097t000000it1TEST' , position.External__c);
        Test.stopTest();
    }
    @isTest
    public static void controllerUpdatesValidTest(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        // publish Advertisement for current object
		controllerObj.updateAdvertisement();
        Test.stopTest();
        System.assertEquals( System.Label.JobAdveirtesement_successfully_updated, ApexPages.getMessages()[0].getSummary() );
    }
    @isTest
    public static void controllerRemoveValidTest(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        JobAdvertisementController controllerObj = new JobAdvertisementController();       
        Test.startTest();
        // remove Advertisement for current object
        controllerObj.removeAdvertisement();
        position = [SELECT External__c, Publication_Status__c FROM Position__c where id =: position.id][0];
        System.assertEquals( null , position.External__c);
        System.assertEquals( 'Not posted' , position.Publication_Status__c);
    }
    @isTest
    public static void controllerSelectionsValidTest(){
        TestDataFactory.insertMockCustomSettings();
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
        Test.setMock(HttpCalloutMock.class, new MockAPICallerGenerator());
        JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        String idToSelect = 'a021t00000TestID';
        controllerObj.getJobAdvertisementById(idToSelect);
        System.assertEquals( idToSelect, controllerObj.currentJA.id);
        Test.stopTest();
    }
    @isTest
    public static void JobAdvertisementControllerInalidAuthTest(){        
        TestDataFactory.insertMockCustomSettings();
		Test.setMock(HttpCalloutMock.class, new MockAPICallerGeneratorInvalidJSONAuth());
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
		JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        controllerObj.api = new APICaller();
        controllerObj.login();
        Test.stopTest();
        System.assert(controllerObj.connected == false); 
        System.assertEquals('Connection failed', ApexPages.getMessages()[0].getSummary() );
    }
    @isTest
    public static void JobAdvertisementControllerInalidFetchPositionTest(){
        Position__c position = TestDataFactory.createPositions(1)[0];
        ApexPages.currentPage().getParameters().put('id',position.id);
		JobAdvertisementController controllerObj = new JobAdvertisementController();
        Test.startTest();
        boolean isException = false;
        controllerObj.fetchPosition( null );
        Test.stopTest();
        System.assert(ApexPages.getMessages()[0].getSummary().contains(System.Label.PositionFetchingException) );
    }
}