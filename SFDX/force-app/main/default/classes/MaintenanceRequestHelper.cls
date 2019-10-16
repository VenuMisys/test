public class MaintenanceRequestHelper {
    
    
    private static List<Work_Part__c> allWorkParts = new List<Work_Part__c>();
    
    public static void updateWorkOrders(Map<Id, Case> insertNewCases){
        List<Case> newCases = new List<Case>(); 
        Map<Id, List<Work_Part__c>> maintWorkPartMap = createMaintWorkPartMap(insertNewCases.keyset());
        Integer shortestMaintCycle;
        // update workorders
        for(Case a: insertNewCases.values()){
            
            List<Work_Part__c> workParts = maintWorkPartMap.get(a.Id);
            if(workParts != null){
                shortestMaintCycle = Integer.valueOf(findShortestMaintCycle(workParts));    
            }
            
            Case newCase = new Case();
            newCase.Vehicle__c = a.Vehicle__c;
            newCase.Equipment__c = a.Equipment__c;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = String.isBlank(a.Subject) ? 'Routine Maintenance Request' : a.Subject;
            newCase.Date_Reported__c = Date.today();
            newCase.Status = 'New';
            newCase.Product__c = a.Product__c;
            newCase.AccountId = a.AccountId;
            newCase.ContactId = a.ContactId;
            newCase.AssetId = a.AssetId;
            newCase.Origin = a.Origin;
            newCase.Reason = a.Reason;
            if(shortestMaintCycle != null)
            newCase.Date_Due__c =  Date.today().addDays(Integer.valueOf(shortestMaintCycle));
            newCases.add(newCase);
        }
        if(newCases.size() > 0){
            insert newCases;
        }


    }  
         
      private static Decimal findShortestMaintCycle(List<Work_Part__c> workParts){
        Decimal shortestValue;
        if(workParts.size()>0){
            shortestValue = workParts.get(0).Equipment__r.Maintenance_Cycle__c;
        }
        for(Work_Part__c singleWorkPart : workParts){
            if(singleWorkPart.Equipment__r.Maintenance_Cycle__c < shortestValue){
                shortestValue = singleWorkPart.Equipment__r.Maintenance_Cycle__c;
            }
        }
        return shortestValue;
    }
    
    private static Map<Id, List<Work_Part__c>> createMaintWorkPartMap(Set<ID> caseIds){
        //Fetch all WorkPart details
        allWorkParts = [SELECT ID, Equipment__c, Maintenance_Request__c, 
                        Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Part__c 
                        WHERE Maintenance_Request__c in: caseIds];
        Map<Id, List<Work_Part__c>> maintWorkPartMap = new Map<Id, List<Work_Part__c>>();
        for(Work_Part__c singleWorkPart : allWorkParts){
            List<Work_Part__c> tempList;
            if(maintWorkPartMap.get(singleWorkPart.Maintenance_Request__c) == null){
                tempList = new List<Work_Part__c>();
            }else{
                tempList = maintWorkPartMap.get(singleWorkPart.Maintenance_Request__c);
            }
            tempList.add(singleWorkPart);
            maintWorkPartMap.put(singleWorkPart.Maintenance_Request__c, tempList);
        }
        
        return maintWorkPartMap;
    }
}