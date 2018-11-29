public class CVJob {
    // make 3 reties to login and fetch total count of new CVs
    private Integer retries = 3;
    public static Integer callouts = 4;
    public static Integer calloutSize = 25;
    public static Integer batchSize = callouts*calloutSize;
    CVApiCaller cvApi = new CVApiCaller();
	
    public void fetchCVs(){
        Integer count = 0;
        OAuth2 authVar;
        try{
            cvApi.oauthLogin();            
            authVar = cvApi.oauth;
            count = cvApi.fetchCVsCount();
        }catch(Exception e){
            if( retries > 0 ){
                retries--;
                fetchCVs();
            }else{ System.debug( e.getMessage()); }            
        }
        List < List<Integer> > offsets;
        System.debug( ' count => ' + count );
        if( count > 0) {
            offsets = calculateOffsets(count);
            CVBatchable batch = new CVBatchable( offsets , authVar , calloutSize, false); 
            database.executebatch( batch, 1 );
        }
    }
    public static List < List<Integer> > calculateOffsets(Integer count){
        Integer batchObjects;
        List < List<Integer> > offsets = new List < List<Integer> >();
        if( count > batchSize ){
            batchObjects = count/batchSize;
            Integer offset = 0;
            for( Integer i = 0; i < batchObjects; i++ ){
                List<Integer> offsetsForCurrentBatch = new List <Integer>();
                for(Integer k = 0; k < callouts; k++ ){
                    offsetsForCurrentBatch.add(offset);
                    offset += calloutSize;
                }
                offsets.add(offsetsForCurrentBatch);
            }
            if( Math.mod( count, batchSize ) != 0 ){
                List<Integer> offsetsForCurrentBatch = new List <Integer>();
                while( offset < count ){
                    offsetsForCurrentBatch.add(offset);
                    offset += calloutSize;
                }
                offsets.add(offsetsForCurrentBatch);
            } 
        }else{
            System.debug( ' batchexecutes = 1; ' );
            batchObjects = 1;
            Integer offset = 0;
            List<Integer> offsetsForCurrentBatch = new List <Integer>();
            while( offset < count ){
                offsetsForCurrentBatch.add(offset);
                offset += calloutSize;
            }
            offsets.add(offsetsForCurrentBatch);
        }
        
        return offsets;
    }  
    public class CVWrapper{
        public String email;        
        public String phone;
        public String cvId;
        public Decimal age;
        public Decimal salary;
        public String name;
        public String status;
        public string additionalInfo;        
        public List <ID> jobs;        
    }
}