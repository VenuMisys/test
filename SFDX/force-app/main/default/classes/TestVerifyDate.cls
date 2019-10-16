@isTest 
private class TestVerifyDate {
    static testMethod void TestVerifyDate() {
        //within 30
        String returnValue=String.valueOf(VerifyDate.CheckDates(Date.newInstance(2015, 2, 15),Date.newInstance(2015, 2, 20)));
            
        //not within 30         
        String returnValue2=String.valueOf(VerifyDate.CheckDates( Date.newInstance(2015, 2, 15) , Date.newInstance(2015, 3, 28) ));
    }
}