@isTest
private class PersonInsertionTest {
    @isTest static void ValidationRecordCreationTest() {
        Person__c p=new Person__c();
        p.First_Name__c='fn2';
        p.Last_Name__c='ln2';
        p.Email__c='fn2ln2@gmail.com';
        p.Phone__c='+381604009911';

        Test.startTest();
        //Database.SaveResult result = Database.insert(p, false);
        insert p;
        Test.stopTest();
        System.assert([select ValidatedFieldValue__c from Phone_Validation_Result__c where Person__c=:p.Id].size() > 0);


    }
}