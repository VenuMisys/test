@isTest
private class MaintenanceRequestHelperTest {

     @testSetup
    static void equip_setup(){
        //Equipment SETUP
        List<Product2> lstOfEqpmnts = new List<Product2>();
        
        Product2 eqip = new Product2(Name = 'Test Equipment', 
                                     Maintenance_Cycle__c = 10,
                                     Cost__c = 100,
                                     Current_Inventory__c = 10,
                                     Lifespan_Months__c = 10,
                                     Replacement_Part__c = true,
                                     Warehouse_SKU__c = 'abc');
        lstOfEqpmnts.add(eqip);
        INSERT lstOfEqpmnts;
    }
    
    
	@isTest static void test_method_one() {

		List<Case> caseList = new List<Case>();
		List<Case> secondList = new List<Case>();
        List<Work_Part__c> partList = new List<Work_Part__c>();


		Account acc = new Account();
		acc.Name = 'test';
		insert acc;

		Contact contact = new Contact();
		contact.FirstName = 'test';
		contact.LastName = 'last';
		contact.Email = 'test@test.com';
		contact.AccountId = acc.Id;
		insert contact;

		Vehicle__c vehicle = new Vehicle__c();
		vehicle.Name = 'car';
		insert vehicle;

		Product2 product = new Product2();
		product.Name = 'test';
		product.isActive = true;
		product.Maintenance_Cycle__c = 5;
		product.Replacement_Part__c = true;
		insert product; 
        Id equipId = [SELECT Id FROM Product2 LIMIT 1].get(0).Id;
		for(Integer i=1;i<=300;i++){
			Case maintenanceNew             = new Case();
			maintenanceNew.Subject          = 'Other';
			maintenanceNew.Vehicle__c       = vehicle.Id;
			maintenanceNew.ContactId        = contact.Id;
			maintenanceNew.AccountId        = acc.Id;
			maintenanceNew.Type             = 'Other';
			maintenanceNew.Status           = 'New';
			maintenanceNew.Equipment__c     = equipId;
			maintenanceNew.Date_Reported__c = Date.today();
			maintenanceNew.Date_Due__c      = Date.today();
			caseList.add(maintenanceNew);	
		}

		insert caseList;
        system.debug('case size' +caseList.size());
        
        for(case cs: caseList){
            Work_Part__c wp = new Work_Part__c();
            wp.Equipment__c = equipId;
            wp.Maintenance_Request__c = cs.id;
            wp.Quantity__c = 1;
            partList.add(wp);
            
        }
        
         for(case cs: caseList){
            Work_Part__c wp = new Work_Part__c();
            wp.Equipment__c = product.id;
            wp.Maintenance_Request__c = cs.id;
            wp.Quantity__c = 1;
            partList.add(wp);
            
        }
        
        insert partList;
        system.debug('part size' +partList.size());
        
      Test.startTest();
		for(Case cas:caseList){
			//update information
			cas.Type = 'Repair';
			cas.Status = 'Closed';
			secondList.add(cas);
		}

		update secondList;
		List<Case> createdCases = [Select Id from Case where Type = 'Routine Maintenance'];
		System.assertEquals(300,createdCases.size());
        Test.stopTest();
	
	}	
}