global class CVBatchable implements Database.Batchable<List<Integer>>, Database.Stateful, Database.AllowsCallouts {
    global CVApiCaller cvApi;
    global Integer limitSize;
    public boolean isRetry;
    public Integer authRetries = 10;
    public List<List<Integer>> offsets;
    public List<List<Integer>> offsetsToRetry = new List<List<Integer>>();
    public CVBatchable(List<List<Integer>> offsets , OAuth2 authvar, Integer limitSize, boolean isRetry){
        this.cvApi = new CVApiCaller();
        this.offsets = offsets;
        this.isRetry = isRetry;
        this.cvApi.oauth = authvar;
        this.limitSize = limitSize;
    }
    global Iterable<List<Integer>> start(Database.BatchableContext bc ) {
		return offsets ;
    }

	global void execute( Database.BatchableContext BC, List<List<Integer>> offsets){  
    	// NEED HACK
        List <CVImageWrapper> cvsWrapped  = new List <CVImageWrapper> ();
        for( List<Integer> offset: offsets){
            for(Integer calloutOffset : offset){
                try{
                    try{
                        List <CVImageWrapper> fetchedCVs = fetchCVRecords( calloutOffset, this.limitSize );
                        System.debug('fetchedCVs ' + fetchedCVs.size());
                        cvsWrapped.addall( fetchedCVs );
                    }catch( Task6Exception e ){
                        if( e.getMessage() == 'Retry auth' && authRetries > 0 ){
                            this.authRetries--;
                            this.cvApi.oauthLogin();
                            List <CVImageWrapper> fetchedCVs = fetchCVRecords( calloutOffset, this.limitSize );
                            System.debug('fetchedCVs ' + fetchedCVs.size());
                        	cvsWrapped.addall( fetchedCVs );
                        }else{
                            if( !isRetry ) offsetsToRetry.add( new List<Integer>{calloutOffset});
                        }
                    }
                }catch( Exception e ){
                    System.debug( 'Exception during fetching with offset: ' + calloutOffset );
                    System.debug( e.getMessage() );
                    if( !isRetry ) offsetsToRetry.add( new List<Integer>{calloutOffset});
                }
            }
        }
        System.debug('upserted ' + cvsWrapped.size());
        CVBatchableService.upsertCandidatesCV(cvsWrapped);
        
    }
    global void finish(Database.BatchableContext BC){
        if( !offsetsToRetry.isEmpty() && !isRetry ){
            System.debug('offsetsToRetry,size() => ' + offsetsToRetry.size());
            // make Retry for each unsuccessful callout
            CVBatchable retryBatch = new CVBatchable( offsetsToRetry, this.cvApi.oauth, limitSize , true );
            System.scheduleBatch( retryBatch, 'Retry fetching ' + Crypto.getRandomLong(), 1, 4 );
        }
    }
    public List<CVImageWrapper> fetchCVRecords(Integer offset,Integer limitSize){
        String cvs = cvApi.fetchCVs(offset, limitSize);            
        List<CVImageWrapper> cvsWrapped = ( List <CVImageWrapper> )System.JSON.deserialize( cvs, List<CVImageWrapper>.class );        
        System.debug('cvsWrapped for callout' + cvsWrapped.size());
        return cvsWrapped;
    }
    
}