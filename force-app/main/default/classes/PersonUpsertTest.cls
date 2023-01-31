@isTest
public class PersonUpsertTest {

    @isTest public static void concatFullName_insertPerson_nameMatches(){
        Person__c testPers= TestDataFactory.createPeople('Test', 1)[0];
        Test.startTest();
        insert testPers;
        System.assertEquals(true, PersonUpsertLogicWrapper.hasConcated, 'Function did not run');
        Test.stopTest();
        Person__c newPers=[select Name from Person__c where Id=:testPers.Id limit 1];
        System.assertEquals(testPers.First_Name__c+' '+testPers.Last_Name__c, newPers.Name, 'Full name is incorrect');
    }

    @isTest public static void concatFullName_updatePersonDiffContext_nameMatches(){
        Person__c testPers= TestDataFactory.createPeople('Test', 1)[0];
        insert testPers;
        testPers.First_Name__c='Pera';
        Test.startTest();
        update testPers;
        System.assertEquals(true, PersonUpsertLogicWrapper.hasConcated, 'Function did not run');
        Test.stopTest();
        Person__c newPers=[select Name from Person__c where Id=:testPers.Id limit 1];
        System.assertEquals(testPers.First_Name__c+' '+testPers.Last_Name__c, newPers.Name, 'Full name is incorrect');
    }

    //update with change
    //update without change

    //insert then update, matches last value
}