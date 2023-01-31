@isTest
public class PersonTriggerTest {

    @isTest public static void concatFullName_insertPerson_nameMatches(){
        Person__c testPers= TestDataFactory.createPeople('Test', 1)[0];
        Test.startTest();
        insert testPers;
        System.assertEquals(1, PersonTriggerLogicWrapper.hasConcatedCount, 'Method should have set full name once');
        Test.stopTest();
        Person__c newPers=[select Name from Person__c where Id=:testPers.Id limit 1];
        System.assertEquals(testPers.First_Name__c+' '+testPers.Last_Name__c, newPers.Name, 'Full name is incorrect');
    }

    @isTest public static void concatFullName_updatePersonSameContext_nameMatches(){
        Person__c testPers= TestDataFactory.createPeople('Test', 1)[0];
        Test.startTest();
        insert testPers;
        testPers.First_Name__c='Pera';
        update testPers;
        System.assertEquals(2, PersonTriggerLogicWrapper.hasConcatedCount, 'Method should have set full name twice');
        Test.stopTest();
        Person__c newPers=[select Name from Person__c where Id=:testPers.Id limit 1];
        System.assertEquals(testPers.First_Name__c+' '+testPers.Last_Name__c, newPers.Name, 'Full name is incorrect');
    }
    @isTest public static void concatFullName_updateNoChange_noMethodRun(){
        Person__c testPers= TestDataFactory.createPeople('Test', 1)[0];
        insert testPers;
        PersonTriggerLogicWrapper.hasConcatedCount=0;
        testPers.City__c='Belgrade';
        Test.startTest();
        update testPers;
        System.assertEquals(0, PersonTriggerLogicWrapper.hasConcatedCount, 'Method ran when there was no name change');
        Test.stopTest();
    }

    //update without change

    //insert then update, matches last value
}