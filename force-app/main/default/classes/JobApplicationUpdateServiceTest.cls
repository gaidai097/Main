@isTest
public class JobApplicationUpdateServiceTest {
	@isTest
    public static void JobApplicationUpdateServiceOneTest(){
       
        Test.startTest();
        TestDataFactory.createJobApplications(1);
        Job_Application__c jobApl = [ Select ID, CreatedById from Job_Application__c][0];
        Task task = JobApplicationUpdateService.createTask(jobApl, 'msg');
        Test.stopTest(); 
        List <Task> tasks = new List<Task>();
        tasks.add(task);
        JobApplicationUpdateService.insertTasks(tasks);
        System.assertEquals( 'msg', task.Subject );    
        System.assertEquals( 1, [ Select ID from Task].size() ); 
    }
}