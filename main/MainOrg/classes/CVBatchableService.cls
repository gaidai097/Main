public class CVBatchableService {
	 
    public static void upsertCandidatesCV( List<CVImageWrapper> wrappedCVs ){
        // Key - Email , value - List <CVImageWrapper> cvsEmails
        Map <String, List<CVImageWrapper> > cvPerEmail = groupWrappedCVsByEmail(wrappedCVs);
        // Key - Email , value - Candidate__c>
        Map <String, Candidate__c> upsertedEmailCandidates = createCandidatesToUpsert(cvPerEmail );
        Map<ID, CVSnapshot__c> snapshotByCVId = createCVSnapshots(wrappedCVs, upsertedEmailCandidates);                
        Map <String, ID> positionsMap = getPositionsMap( wrappedCVs);
        createJobapplications(wrappedCVs, positionsMap, upsertedEmailCandidates, snapshotByCVId);        
    }
        
    public static Map <String, List<CVImageWrapper> > groupWrappedCVsByEmail( List<CVImageWrapper> wrappedCVs ){
        Map <String, List<CVImageWrapper> > cvPerEmail = new Map <String,  List<CVImageWrapper> >();
        for( CVImageWrapper wrappedCV: wrappedCVs){
            if(cvPerEmail.get(wrappedCV.email) == null){
                cvPerEmail.put( wrappedCV.email , new List<CVImageWrapper>{wrappedCV});
            }else{
                cvPerEmail.get(wrappedCV.email).add(wrappedCV);
            } 
        }
        return cvPerEmail;
    }    
    public static Map <String, Candidate__c>  createCandidatesToUpsert( Map <String, List<CVImageWrapper> > cvPerEmail ){
        
        List <Candidate__c> candidatesToUpsert = new List <Candidate__c>();   
        for( String email: cvPerEmail.keySet()){
            Candidate__c newCandidate = formCandidateWithCVWrapper(cvPerEmail.get(email)[0] );
            candidatesToUpsert.add(newCandidate);
        }
        system.debug('candidatesToUpsert =>' + candidatesToUpsert);
        system.debug('exist =>' + [Select ID, Email__c from Candidate__c]);
        Database.upsert(candidatesToUpsert, Candidate__c.email__c);
        
        System.debug('candidatesToUpsert ' + candidatesToUpsert.size());
        Map <String, Candidate__c> upsertedEmailCandidates = new Map <String, Candidate__c >();
        for( Candidate__c candidate: candidatesToUpsert){
            upsertedEmailCandidates.put( candidate.Email__c , candidate);
        }
        return upsertedEmailCandidates;
    }
    // inset fields from first CV to Candidate record 
    public static Candidate__c formCandidateWithCVWrapper( CVImageWrapper cvWrapped){
        Candidate__c candidate = new Candidate__c( Email__c = cvWrapped.email);
        candidate.Currently_Employed__c = cvWrapped.status == 'Employeed'? true : false;
        if( candidate.Currently_Employed__c == false){
            candidate.Current_Employer__c = null;
        }
        candidate.Phone__c = cvWrapped.phone;
        List<String> brakets = cvWrapped.Name.split('');
        candidate.First_Name__c = brakets[0];
        candidate.Last_Name__c = brakets[1];
        return candidate ;
    }
    // form map of JobAdvertisement.Id and Position.Id
    public static Map <String, ID> getPositionsMap( List <CVImageWrapper> wrappedCVs){
        
        Set <ID> jobAdvertisementIds = selectJobAdvertisementIds(wrappedCVs); 
        //Put all positions selected by candidates throw the JobAdvertisement.Id
        Map <String, ID> postionsMap = new Map <String, ID>();
        for(Position__c position: [ SELECT ID, Name, External__c FROM Position__c WHERE External__c IN :jobAdvertisementIds ] ){
            postionsMap.put( position.External__c, position.id);
        }
        return postionsMap;
    }
    public static Set <ID>  selectJobAdvertisementIds(List <CVImageWrapper> wrappedCVs){
        Set <ID> jobAdvertisementIds = new Set <ID>();  
        for( CVImageWrapper cvWrapped : wrappedCVs){
            jobAdvertisementIds.addall( cvWrapped.jobs );
        }
        return jobAdvertisementIds;
    }
    public static Map < ID, CVSnapshot__c > createCVSnapshots( List<CVImageWrapper>  cvsWrapped ,  Map <String, Candidate__c> upsertedEmailCandidates){
        
        Map < ID, CVSnapshot__c > snapshotByCVId = new Map <ID , CVSnapshot__c>();
        for(CVImageWrapper cvWrapped: cvsWrapped ){
            CVSnapshot__c snapshot = new CVSnapshot__c( Name = cvWrapped.name , Email__c = cvWrapped.email, 
                                                       Phone__c = cvWrapped.phone, Age__c = cvWrapped.age,
                                                       Candidate__c = upsertedEmailCandidates.get(cvWrapped.email).Id,
                                                       Additional_info__c = cvWrapped.additionalInfo ,
                                                       ImageId__c = cvWrapped.contentVersionId , Salary__c = cvWrapped.salary,
                                                       Employement__c = cvWrapped.status == 'Employeed'? true : false
                                                      );
            snapshotByCVId.put(cvWrapped.cvId, snapshot);
        }
        insert snapshotByCVId.values();
        return snapshotByCVId;
    }
   
    public static void createJobapplications( List<CVImageWrapper> wrappedCVs, Map <String, ID> positionsMap,
                                                                  Map <String, Candidate__c> upsertedEmailCandidates,  Map<ID, CVSnapshot__c> snapshotByCVId ){
        List <Job_Application__c> applications = new List <Job_Application__c>();
        for(CVImageWrapper wrappedCV : wrappedCVs){
            for(ID jobAdvertisementId: wrappedCV.jobs ){
                Job_Application__c jobApplication = new Job_Application__c(
                    Position__c = positionsMap.get(jobAdvertisementId),
                    Candidate__c = upsertedEmailCandidates.get(wrappedCV.email).Id,
                    CVSnapshot__c = snapshotByCVId.get(wrappedCV.cvId).Id
                );
                applications.add(jobApplication);
            }
        }
        insert applications;
        System.debug( ' =======*********==========**********===== '  );
        System.debug( ' jobApplications ' + applications.size() );
    }    	
}