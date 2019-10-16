@isTest
private class TestRestrictContactByName {
    @isTest static void test1(){
        contact c = new Contact();
        c.LastName = 'INVALIDNAME';
        // Perform test
        Test.startTest();
        insert c;
        Test.stopTest();
    }
     @isTest static void test2(){
        contact c = new Contact();
        c.LastName = 'Devi';
        // Perform test
        Test.startTest();
        insert c;
        Test.stopTest();
    }

}