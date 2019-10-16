@isTest
public class WarehouseSyncScheduleTest {
    @isTest
    static void WarehouseSyncSchedule(){
        Test.StartTest();
        WarehouseSyncSchedule sh1 = new WarehouseSyncSchedule();
        
        String sch = '0 0 1 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
    }
}