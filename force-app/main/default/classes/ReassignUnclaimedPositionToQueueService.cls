public class ReassignUnclaimedPositionToQueueService {
	    
    public static Id getUnclaimedPositionQueueId(){      
        
        QueueSObject queue = [SELECT  QueueId   FROM QueueSObject where Queue.Name = 'Unclaimed Positions Queue' LIMIT 1];
        
        return  queue.QueueId ;        
    }
    
    public static List<Id> getRecrutersIds(){ 
            List <Id> roleIds = getRecrutersRolesIds();
            List <Id> recruitersIds = new List <Id>();
            for(User recruiter: [SELECT Id FROM User WHERE UserRoleId  In :roleIds]){
                recruitersIds.add(recruiter.Id);
            }
            return recruitersIds;
        
    }
    public static List<Id> getRecrutersRolesIds(){
        List <Id> roleIds = new List <Id>();
        List <UserRole> roles = [SELECT Id FROM UserRole WHERE name LIKE '%Recruiter%' OR name LIKE '%Recruiting Manager%'];
        for(UserRole role: roles){
            roleIds.add(role.Id);
        }
        return roleIds;
    }
   
}