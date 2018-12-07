public class CVJob {
    // make 3 retries to login and fetch total count of new CVs
    private Integer retries = 3;
    public Integer count = 0;
    public static Integer callouts = 4;
    public static Integer calloutSize = 25;
    public static Integer batchSize = callouts*calloutSize;
    CVApiCaller cvApi = new CVApiCaller();
	
    public void fetchCVs(){        
        try{
            cvApi.oauthLogin();     
            count = cvApi.fetchCVsCount();
        }catch(Exception e){
            if( retries > 0 ){
                retries--;
                fetchCVs();
            }else{ 
                System.debug( e.getTypeName() + '  ' + e.getMessage() + '  ' + e.getStackTraceString() );
                EmailServices.sendEmailToAdmins(Label.New_CVs_were_not_recieved_successfully + ': ' + e.getTypeName() + ' ; '
                                                + e.getMessage() + ' ; ' 
                                                + e.getStackTraceString()  + ' '+ System.now());
            }            
        }
        System.debug( ' Count of new CVs on Site=> ' + count );
        if( count > 0) runBatchableProcess();
    }
    public void runBatchableProcess(){
        List < List<Integer> > offsets = calculateOffsets();
        CVBatchable batch = new CVBatchable( offsets , cvApi.oauth , calloutSize, false); 
        database.executebatch( batch, 1 );
    }
    public List< List<Integer> > calculateOffsets(){
        List < List<Integer> > offsets = new List < List<Integer> >();
        if( count <= batchSize ){ 
            offsets.add( formLastArray( 0 ));
        }else{            
            formMultipleExecutesArray(offsets);
        }
        return offsets;
    }
    public List<Integer> formLastArray(Integer offset){
        List<Integer> offsetsForCurrentBatch = new List <Integer>();
        while( offset < count ){
            offsetsForCurrentBatch.add(offset);
            offset += calloutSize;
        }
        return offsetsForCurrentBatch;
    }
    public void formMultipleExecutesArray( List < List<Integer> > offsets ){
        Integer offset = 0;
        for( Integer i = 0; i < count/batchSize; i++ ){
            List<Integer> offsetsForCurrentBatch = new List <Integer>();
            for(Integer k = 0; k < callouts; k++ ){
                offsetsForCurrentBatch.add(offset);
                offset += calloutSize;
            }
            offsets.add( offsetsForCurrentBatch );
        }
        if( Math.mod( count, batchSize ) != 0 ) offsets.add( formLastArray( offset ));        
    }
}