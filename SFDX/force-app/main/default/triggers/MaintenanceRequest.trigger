trigger MaintenanceRequest on Case (before update, after update) {
    // call MaintenanceRequestHelper.updateWorkOrders  
    Map<Id,Case> insertNewCases = new Map<Id,Case>();

    if(Trigger.isUpdate  && Trigger.isAfter){
        for(Case oCase: Trigger.new){
            if (oCase.IsClosed && (oCase.Type.equals('Repair') || oCase.Type.equals('Routine Maintenance'))){
                insertNewCases.put(oCase.Id, oCase);
            }
        }
        if(!insertNewCases.values().isEmpty()){
        	MaintenanceRequestHelper.updateWorkOrders(insertNewCases);    
        }        
    } 
    
}