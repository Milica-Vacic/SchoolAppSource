@IsTest
public with sharing class PersonControllerTest {
    @isTest
    static void getPersonList_systemContext_ReturnsAllRecordsAndFields() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 2, 'Tutor');
        people.addAll(TestDataFactory.createPeople('student', 3, 'Student'));
        people[0].Phone__c='0604009911';
        PersonTriggerLogicWrapper.skipPhoneValidation=true;
        insert people;

        Test.startTest();
        Map<Id,Person__c> returnedPeople = new Map<Id,Person__c>(PersonController.getPersonList(null, 10, 0));
        Test.stopTest();

        System.assertEquals(5, returnedPeople.size(),'Incorrect number of Person__c records returned');
        for(Person__c p:people){
            String name=String.format('{0} {1}', new List<String>{p.First_Name__c, p.Last_Name__c});
            System.assertEquals(name, returnedPeople.get(p.Id).Name, 'Name does not match expected value');
            System.assertEquals(p.Email__c, returnedPeople.get(p.Id).Email__c, 'Email does not match expected value');
            System.assertEquals(p.Phone__c, returnedPeople.get(p.Id).Phone__c, 'Email does not match expected value');
            System.assertEquals(p.RecordTypeId, returnedPeople.get(p.Id).RecordType.Id, 'RecordType does not match expected value');
        }
    }

    @isTest
    static void getPersonList_accessToOwnedPeople_ReturnsOwnedRecords() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 1, 'Tutor');
        insert people;

        Profile p = [SELECT Id FROM Profile WHERE Name='OwnedPersonRecordsAccess'];
        User user = new User(Alias = 'minusr', Email='minimumuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='minimumuser@testorg.com');
        insert user;

        System.runAs(user) {
            List<Person__c> ownedPeople=TestDataFactory.createPeople('ownedTutor', 1, 'Tutor');
            insert ownedPeople;
            Test.startTest();
            List<Person__c> returnedPeople = PersonController.getPersonList(null, null, null);
            System.assertEquals(1, returnedPeople.size(),'Incorrect number of Person__c records returned');
            System.assertEquals(ownedPeople[0].Id, returnedPeople[0].Id,'Incorrect Person__c record returned');
            Test.stopTest();
        }
    }

    @isTest
    static void getPersonList_accessToRequiredFields_StripsInacessibleFields() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 1, 'Tutor');
        people[0].Phone__c='0604009911';
        PersonTriggerLogicWrapper.skipPhoneValidation=true;
        insert people;

        Profile profile = [SELECT Id FROM Profile WHERE Name='AllPersonRecordsAccess'];
        User user = new User(Alias = 'minusr', Email='minimumuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = profile.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='minimumuser@testorg.com');
        insert user;

        System.runAs(user) {   
            Test.startTest();
            Map<Id,Person__c> returnedPeople = new Map<Id,Person__c>(PersonController.getPersonList(null, null, null));
            System.assertEquals(1, returnedPeople.size(),'Incorrect number of Person__c records returned');
            
            for(Person__c p:people){
                try {
                    String phone=returnedPeople.get(p.Id).Phone__c;
                    System.Assert(false,'Exception should have been thrown, Phone__c should not have been returned');
                } catch(SObjectException e){}
                String name=String.format('{0} {1}', new List<String>{p.First_Name__c, p.Last_Name__c});
                System.assertEquals(name, returnedPeople.get(p.Id).Name, 'Name does not match expected value');
                System.assertEquals(p.Email__c, returnedPeople.get(p.Id).Email__c, 'Email does not match expected value');
                System.assertEquals(p.RecordTypeId, returnedPeople.get(p.Id).RecordType.Id, 'RecordType does not match expected value');
            }

            Test.stopTest();
        }
    }

    @isTest
    static void getPersonList_nonEmptySearchKey_ReturnsMatchingRecords() {
        List<Person__c> people=TestDataFactory.createPeople('first', 2, 'Tutor');
        people.addAll(TestDataFactory.createPeople('second', 2, 'Student'));
        people[3].Phone__c='0604009911';
        people[1].Email__c='testEmail@gmail.com';
        PersonTriggerLogicWrapper.skipPhoneValidation=true;
        insert people;

        Test.startTest();
        Map<Id,Person__c> matchingNameReturn = new Map<Id,Person__c>(PersonController.getPersonList('first',null,null));
        System.assertEquals(2, matchingNameReturn.size(),'Incorrect number of Person__c records returned for search key \'first\'');
        System.assert(matchingNameReturn.keySet().contains(people[0].Id) && matchingNameReturn.keySet().contains(people[1].Id),'Incorrect  records returned for search key \'first\'');

        Map<Id,Person__c> matchingPhoneReturn = new Map<Id,Person__c>(PersonController.getPersonList('04009',null,null));
        System.assertEquals(1, matchingPhoneReturn.size(),'Incorrect number of Person__c records returned for search key \'04009\'');
        System.assert(matchingPhoneReturn.keySet().contains(people[3].Id),'Incorrect  records returned for search key \'04009\'');

        Map<Id,Person__c> matchingEmailReturn = new Map<Id,Person__c>(PersonController.getPersonList('testEmail',null,null));
        System.assertEquals(1, matchingEmailReturn.size(),'Incorrect number of Person__c records returned for search key \'testEmail\'');
        System.assert(matchingEmailReturn.keySet().contains(people[1].Id),'Incorrect  records returned for search key \'testEmail\'');

        Map<Id,Person__c> matchingMixedReturn = new Map<Id,Person__c>(PersonController.getPersonList('0',null,null));
        System.assertEquals(3, matchingMixedReturn.size(),'Incorrect number of Person__c records returned for search key \'0\'');
        System.assert(!matchingMixedReturn.keySet().contains(people[1].Id),'Incorrect  records returned for search key \'0\'');
        Test.stopTest();
    }

    @isTest
    static void getPersonRecordTypes_returnsListOfRecordTypes() {
        Test.startTest();
        List<RecordType> personTypes=PersonController.getPersonRecordTypes();
        System.assert(personTypes instanceOf List<RecordType>,'Returned value does not match the expected type');
        Test.stopTest();
    }

    @isTest
    static void deletePerson_personParameterRecieved_DeletesPerson() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 2, 'Tutor');
        insert people;
        Test.startTest();
        PersonController.deletePerson(people[0]);
        List<Person__c> returnedPeople=[SELECT Id from Person__c];
        System.assertEquals(1, returnedPeople.size(),'Unexpected number of records found after deletion');
        System.assertEquals(people[1].Id, returnedPeople[0].Id,'Incorrect record was deleted');
        Test.stopTest();
    }

 
}