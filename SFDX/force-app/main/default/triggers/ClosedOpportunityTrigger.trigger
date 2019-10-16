trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    //adds a 'Follow Up Test Task' to any opportunity set to 'Closed Won'
    List<Task> lstTask = new List<Task>();
    //Iterate over Opptys that are in this trigger and Closed Won
    for (Opportunity o : [SELECT Id, StageName FROM Opportunity WHERE Id IN :Trigger.New AND StageName = 'Closed Won']){
        //add Follow Up Task to this Oppty
        lstTask.add(new Task(Subject = 'Follow Up Test Task',
                            WhatId = o.Id));
    }
    
    if (lstTask.size() > 0)
        insert lstTask;
}