@isTest
public class JobApplicationUpdateTest {
	@isTest
    public static  void JobApplicationUpdateTwoValidTest() {  
        
        List <Job_Application__c> jobApplications = TestDataFactory.createJobApplications(2);
        jobApplications[0].Status__c = 'Rejected';
        jobApplications[1].Status__c = 'Extend an Offer';
        update jobApplications;
        List <Task> tasks = [Select Id, Subject from Task order by Subject];
        
        System.assertEquals (2, tasks.size()); 
        System.assertEquals ('Extend an Offer', tasks[0].Subject);
        System.assertEquals ('Send Rejection Letter', tasks[1].Subject);
        
    }
    @isTest
    public static  void JobApplicationUpdateOneAnotherStatusTest() {         
        Job_Application__c jobApplications = TestDataFactory.createJobApplications(1)[0];
        jobApplications.Status__c = 'Closed';
        update jobApplications;
        List <Task> invalidTasks = null;
        JobApplicationUpdateService.insertTasks( invalidTasks);
        List <Task> tasks = [Select Id from Task];
        System.assertEquals (0, tasks.size()); 
       
    }
    @isTest
    public static  void JobApplicationUpdateBulkValidTest() {  
        
        List <Job_Application__c> jobApplications = TestDataFactory.createJobApplications(101);
        jobApplications[0].Status__c = 'Rejected';
        for (integer i= 0; i < 80; i++){
            jobApplications[i].Status__c = 'Rejected';
        }
        for (integer i= 80; i < 101; i++){
            jobApplications[i].Status__c = 'Extend an Offer';
        }
        update jobApplications;
        List <Task> tasks = [Select Id, OwnerId, Subject from Task order by Subject];
        System.assertEquals (101, tasks.size()); 
        System.assertEquals ('Extend an Offer', tasks[0].Subject);
        System.assertEquals ('Extend an Offer', tasks[20].Subject);
        System.assertEquals ('Send Rejection Letter', tasks[22].Subject);
        System.assertEquals ('Send Rejection Letter', tasks[100].Subject);
        System.assertEquals ([Select  CreatedById  from  Job_Application__c][55].CreatedById, tasks[0].OwnerId);
        
    }
    
    
}