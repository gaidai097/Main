public class JobApplicationUpdateService {
	
    public static Task createTask(Job_Application__c jobApl, String msg){
        
        Task task = new Task();
        task.OwnerId = jobApl.CreatedById;      
        task.Subject = msg;
        task.Status = 'Open';
        task.Priority = 'Normal';
        return task;
    } 
    public static void insertTasks(List <Task> tasks){
        try{
            insert tasks;
        }catch(Exception e){
            System.debug('Task insertion issue : ' + e);
        } 
    }
}