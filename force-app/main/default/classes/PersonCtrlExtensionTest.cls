@IsTest
public with sharing class PersonCtrlExtensionTest {
    @isTest
    static void getLayoutFields_StudenthasRecordIdParameter_ReturnsStudentFields() {
        List<Person__c> people=TestDataFactory.createPeople('student', 1, 'Student');
        insert people;
        ApexPages.currentPage().getParameters().put('Id',people[0].id);
	    List<String> fields= PersonCtrlExtension.getLayoutFields();
        Test.startTest();
        System.assert(fields.contains('Passing_Credit_Threshold__c'), 'Returned fields for student do not contain Passing_Credit_Threshold__c');
        System.assert(fields.contains('Passing_Score_Threshold__c'), 'Returned fields for student do not contain Passing_Score_Threshold__c');
        System.assert(!fields.contains('Years_of_experience__c'), 'Returned fields for student contain Years_of_experience__c');
        Test.stopTest();
    }

    @isTest
    static void getLayoutFields_TutorhasRecordTypeParameter_ReturnsTutorFields() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 1, 'Tutor');
        insert people;
        ApexPages.currentPage().getParameters().put('RecordType',people[0].RecordTypeId);
	    List<String> fields= PersonCtrlExtension.getLayoutFields();
        Test.startTest();
        System.assert(!fields.contains('Passing_Credit_Threshold__c'), 'Returned fields for tutor contain Passing_Credit_Threshold__c');
        System.assert(!fields.contains('Passing_Score_Threshold__c'), 'Returned fields for tutor contain Passing_Score_Threshold__c');
        System.assert(fields.contains('Years_of_experience__c'), 'Returned fields for tutor do not contain Years_of_experience__c');
        Test.stopTest();
    }

    @isTest
    static void save_newStudent_editsPhoneAndInsertsRecord() {
        List<Person__c> people=TestDataFactory.createPeople('student', 1, 'Student');
        people[0].Phone__c='12345';
        ApexPages.currentPage().getParameters().put('RecordType',people[0].RecordTypeId);
        ApexPages.StandardController stdPers = new ApexPages.StandardController(people[0]);
	    PersonCtrlExtension objPersonCtrlExtension  = new PersonCtrlExtension(stdPers);

        Test.startTest();
        objPersonCtrlExtension.save();
        Test.stopTest();
        List<Person__c> returnedPeople=[select Id, Phone__c from Person__c];
        System.assertEquals(people.size(),returnedPeople.size(),'Returned record list is not of expected length');
        System.assertEquals(people[0].Id,returnedPeople[0].Id,'Returned record Id does not match expected value');
        System.assertEquals('+381'+people[0].Phone__c,returnedPeople[0].Phone__c,'Returned record Phone__c value does not match expected value');
    }

    @isTest
    static void save_editTutor_EditsRecord() {
        List<Person__c> people=TestDataFactory.createPeople('tutor', 1, 'Tutor');
        insert people;
        ApexPages.StandardController stdPers = new ApexPages.StandardController(people[0]);
	    PersonCtrlExtension objPersonCtrlExtension  = new PersonCtrlExtension(stdPers);
        people[0].First_Name__c='Edited';

        Test.startTest();
        objPersonCtrlExtension.save();
        Test.stopTest();
        List<Person__c> returnedPeople=[select Id, Phone__c, First_Name__c from Person__c];
        System.assertEquals(people.size(),returnedPeople.size(),'Returned record list is not of expected length');
        System.assertEquals(people[0].Id,returnedPeople[0].Id,'Returned record Id does not match expected value');
        System.assertEquals('Edited',returnedPeople[0].First_Name__c,'Returned record First_Name__c value does not match expected value');
        System.assertEquals(null,returnedPeople[0].Phone__c,'Returned record Phone__c value does not match expected value');

    }
}
