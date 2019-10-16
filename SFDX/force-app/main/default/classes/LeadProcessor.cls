global class LeadProcessor implements Database.Batchable <SObject> {
//START METHOD
    global Database.QueryLocator start(Database.BatchableContext bc){
        String Query='Select id,LeadSource from Lead';
        return Database.getQueryLocator(Query);
            }
//EXECUTE METHOD
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        for(Lead l: scope){
            l.LeadSource='DreamForce';
        }
        update scope;
    }
//FINISH METHOD
    global void finish(Database.BatchableContext bc){
        Id job= bc.getJobId();
        System.debug(job);
    }
}