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
        Map<Id,Person__c> returnedPeople = new Map<Id,Person__c>(PersonController.getPersonList());
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
            List<Person__c> returnedPeople = PersonController.getPersonList();
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

        Profile p = [SELECT Id FROM Profile WHERE Name='AllPersonRecordsAccess'];
        User user = new User(Alias = 'minusr', Email='minimumuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='minimumuser@testorg.com');
        insert user;

        System.runAs(user) {   
            Test.startTest();
            List<Person__c> returnedPeople = PersonController.getPersonList();
            System.assertEquals(1, returnedPeople.size(),'Incorrect number of Person__c records returned');
            try{
                String phone=returnedPeople[0].Phone__c;
                System.Assert(false,'Exception should have been thrown, Phone__c should not have been returned');
            }
            catch(SObjectException e){}
            Test.stopTest();
        }
    }

    @isTest
    static void getPersonWithRecordTypeList_passPersonList_ReturnListOfWrappedPersonObjects() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 2, 'Tutor');
        people[0].Phone__c='0604009911';
        PersonTriggerLogicWrapper.skipPhoneValidation=true;
        insert people;
        Test.startTest();
        List<PersonWithRecordTypeName> wrappedPeople= PersonController.getPersonWithRecordTypeList();
        Test.stopTest();
        System.assertEquals(people.size(), wrappedPeople.size(), 'Returnd list is of incorrect length');
        List<Id> typeIds= new List<Id>();
        for(Person__c p: people){
            typeIds.add(p.RecordTypeId);
        }
        Map<Id,RecordType> recordTypes=new Map<Id,RecordType>([select Id, Name from RecordType where Id in :typeIds]);
        for(Integer i=0;i<people.size();i++){
            System.assertEquals(String.format('{0} {1}', new List<String>{people[i].First_Name__c,people[i].Last_Name__c }), wrappedPeople[i].Name, 'Name values do not match');
            System.assertEquals(people[i].Email__c, wrappedPeople[i].Email, 'Email values do not match');
            System.assertEquals(people[i].Phone__c, wrappedPeople[i].Phone, 'Phone values do not match');
            System.assertEquals(recordTypes.get(people[i].RecordTypeId).Name, wrappedPeople[i].RecordType, 'Record type name values do not match');
            System.assertEquals('/'+people[i].Id, wrappedPeople[i].NameUrl, 'Name URL value is not correct');
            System.assertEquals(people[i].Id, wrappedPeople[i].Id, 'Id values do not match');
        }
    }

    //getPersonWithRecordTypeList test with a minimal access user?????????
}