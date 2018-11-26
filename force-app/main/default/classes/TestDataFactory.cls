@isTest
public class TestDataFactory {
	
    public static List <Job_Application__c> createJobApplications(Integer count){
        List <Job_Application__c> jobApplications = new List <Job_Application__c>();
        List <Candidate__c> candidates = createCandidates(count);
        List <Position__c> positions = createPositions(count);
        List <CVSnapshot__c> snapshots = createSnapshots(candidates);
        for(integer i = 0; i < count; i++){
            jobApplications.add( 
                new Job_Application__c( Position__c = positions[i].Id, Candidate__c = candidates[i].Id , CVSnapshot__c = snapshots[i].Id )
            );
        }
        insert jobApplications;
        return jobApplications;
    }

    public static List <Candidate__c> createCandidates(Integer count){
        List <Candidate__c> candidates = new List <Candidate__c>();
        for(integer i = 0; i < count; i++){
            candidates.add(
                new Candidate__c( First_Name__c = 'FirstName'+i, Last_Name__c = 'FirstName'+i ,
                                Email__c = i + 'ddddd134dd@gmail.com')
            );
        }
        insert candidates;
        return candidates;
    }
    public static List <Position__c> createPositions(Integer count){
        List <Position__c> positions = new List <Position__c>();
        for(integer i = 0; i < count; i++){
            positions.add(
                new Position__c( Name = 'Title'+i , external__c = 'someTestId' + i, 
                                Publication_Status__c ='Posted',
                               Status__c = 'Open', Approval_Status__c = 'Approved')
            );
        }
        insert positions;        
        return positions;
    }
    public static List <CVSnapshot__c> createSnapshots(List <Candidate__c> candidates){
        List <CVSnapshot__c> snapshots = new List <CVSnapshot__c>();
        for(Candidate__c candidate: candidates){
            snapshots.add(
                new CVSnapshot__c( Name = candidate.name , Email__c = candidate.Email__c, 
                                                       Phone__c = '09898989898', Age__c = '45',
                                                       Candidate__c = candidate.Id,
                                                       Additional_info__c = 'info' ,
                                                       ImageId__c = 'TESTimageID' , Salary__c = '550',
                                                       Employement__c = true 
                                                      )
            );
        }
        insert snapshots;        
        return snapshots;
    }
   
    public static List <Position__c> createUnclaimedPositions(Integer count){
        List <Position__c> unclaimedPositions = new List <Position__c>();        
        for(integer i = 0; i < count; i++){
            unclaimedPositions.add( 
                // Owner is an Admin (current user)
                new Position__c( Name = 'unclaimedPositionTest '+ i )
            );
        }
        insert unclaimedPositions;        
        return unclaimedPositions;
    }
    public static List <Position__c> createPositionsWithRecruiterOwner(Integer count){
        List <Position__c> createdPositions = new List <Position__c>();
        
        ID id = ReassignUnclaimedPositionToQueueService.getRecrutersIds()[0];
        for(integer i = 0; i < count; i++){
            createdPositions.add( 
                new Position__c( Name = 'createdByRecruiter '+ i , OwnerId = id)
            );
        }
        insert createdPositions;        
        return createdPositions;
    }
    public static void insertMockCustomSettings(){
        OAuth_integration__c settingsAPI = new OAuth_integration__c();
        settingsAPI.clientId__c = 'secretTest';
        settingsAPI.destURL__c = 'https://login.salesforce.com/services/oauth2/token';
        settingsAPI.clientSecret__c = 'secretTest';
        settingsAPI.username__c = 'secretTest';
        settingsAPI.password__c = 'secretTest';
        insert settingsAPI;
    }
    public static Integer generateRandomFromRange(integer startNum, integer endNum){
        Integer returnValue;
        //Logic- first we will generate random boolean value which will decide if we want to
        //add the random number from startNum or will subtract random number from endNum
        Integer randomNumber = Integer.valueof((math.random() * 10));
        boolean addSubFlag= math.mod(randomNumber,2) == 0 ? true : false;
        
        integer diffInRange = endNum-startNum;
        //Now find random number staring from 0 to diffInRange
        Integer randomNum = Math.mod(Math.round(Math.random()*diffInRange+1),diffInRange);
        
        //If addSubFlag is true, we will add random number generated between 0 and diffInRange from start number
        //else we will subtract random number from end number
                if(addSubFlag){
            if(diffInRange > 1)
                returnValue =startNum + randomNum;
            else
                returnValue =startNum;
        }else{
            if(diffInRange > 1)
                returnValue = endNum - randomNum;
            else
                returnValue =endNum;
        }
        return returnValue;
    }
    
    
}