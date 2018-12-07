global class CVScheduled implements Schedulable {
	global void execute( SchedulableContext ctx ) {
        
        CVJob cvjob = new CVJob ();
        cvjob.fetchCVs();
    }  
}