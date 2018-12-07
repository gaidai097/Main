public class JobAdvertisementsWrapper {
    public String salary {get;set;}
    public String salaryMax {get;set;}
    public String salaryMin {get;set;}
    public String email {get;set;}
    public String phone {get;set;}
    public String status {get;set;}
    //current id => externalId => JobAdvertisement__c.Id
    public String id {get;set;}
    public String name {get;set;}
    public String skills {get;set;}
    public String description {get;set;}
    public String manager_name {get;set;}
    public String education {get;set;}
    public String location {get;set;}
    
    public static JobAdvertisementsWrapper convertPosition(Position__c position){        
        JobAdvertisementsWrapper result = new JobAdvertisementsWrapper();
        fillSalaryRange(result, position);
        result.location = position.Location__c;
        result.education = position.Education__c;
        result.email = position.Hiring_Manager__r.Email;
        result.phone = position.Hiring_Manager__r.Phone;
        result.name = position.Name;
        result.status = position.Status__c;
        result.manager_name = position.Hiring_Manager__r.Name;
        result.description = position.Job_Description__c;
        result.skills = position.Skills_Required__c;
        result.id = position.External__c;
        return result ;
    }
    public static void fillSalaryRange(JobAdvertisementsWrapper result ,Position__c position){
        if(position.Salary_Range__c != null && position.Salary_Range__c != ''){
            List <Integer> values = reformSalaryRange(position.Salary_Range__c);           
            if(values.size()> 0){
                result.salaryMin = values[0] + '';
                if(values.size() == 2){
                    result.salaryMax = values[1] + '';
                }
            }
        }
    }
    public static List <Integer> reformSalaryRange(String salaryRange){
        List <String> levels = salaryRange.split('K');
        List <Integer> values = new List <Integer>();
        for(String level: levels){
            String stringLevel = '';
            for(integer i =0; i <level.length();i++){
                String currentChar = level.mid(i,1);
                if(currentChar.isNumeric()){
                    stringLevel += currentChar;
                }
            }if(stringLevel.length() > 0){
                values.add( integer.valueof(stringLevel) );
            }
        }
        return values;
    }
}