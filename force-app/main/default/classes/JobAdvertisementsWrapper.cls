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
        result.location = position.Location__c;
        if(position.Salary_Range__c != null && position.Salary_Range__c != ''){
            List <String> statutes = position.Salary_Range__c.split('K');
            List <Integer> values = new List <Integer>();
            for(String st: statutes){
                String numericString = '';
                for(integer i =0; i <st.length();i++){
                    System.debug( 'st ' + st);
                    String s= st.mid(i,1);
                    if(s.isNumeric()){
                        numericString +=s;
                    }
                }if(numericString.length() > 0){
					values.add( integer.valueof(numericString) );
				}                
            }
            if(values.size()> 0){
                result.salaryMin = values[0] + '';
                if(values.size() == 2){
                    result.salaryMax = values[1] + '';
                }
            }
        }
        result.education = position.Education__c;
        result.email = position.Hiring_Manager__r.Email;
        result.phone = position.Hiring_Manager__r.Phone;
        result.name = position.Name;
        result.manager_name = position.Hiring_Manager__r.Name;
        result.description = position.Job_Description__c;
        result.skills = position.Skills_Required__c;
        result.id = position.External__c;
        return result ;
    }
}