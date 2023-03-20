@IsTest
public with sharing class PopupControllerTest {
    @isTest
    static void showPopup_closePopup_toggleIsVisible() {
        List<Person__c> people=TestDataFactory.createPeople('student', 1, 'Student');
        ApexPages.StandardSetController stdPers = new ApexPages.StandardSetController(people);
	    PopupController objPopupController  = new PopupController(stdPers);

        Test.startTest();
        objPopupController.showPopup();
        System.assertEquals(true,objPopupController.isVisible,'Popup should be set to visible');

        objPopupController.closePopup();
        System.assertEquals(false,objPopupController.isVisible,'Popup should be set to not visible');
        Test.stopTest();
    }

    @isTest
    static void deletePerson_existingPerson_PersonDeleted() {
        List<Person__c> people=TestDataFactory.createPeople('student', 1, 'Student');
        insert people;
        ApexPages.StandardSetController stdPers = new ApexPages.StandardSetController(people);
	    PopupController objPopupController  = new PopupController(stdPers);

        Test.startTest();
        objPopupController.person=people[0];
        objPopupController.deletePerson();
        List<Person__c> returnedPeople = [SELECT Id FROM Person__c];
        System.assertEquals(0,returnedPeople.size(),'Record was not successfuly deleted');
        Test.stopTest();
    }

    @isTest
    static void getPeople_returnsAllPeople() {
        List<Person__c> people=TestDataFactory.createPeople('student', 3, 'Student');
        insert people;
        ApexPages.StandardSetController stdPers = new ApexPages.StandardSetController(people);
	    PopupController objPopupController  = new PopupController(stdPers);

        Test.startTest();
        List<Person__c> returnedPeople = objPopupController.getPeople();
        System.assertEquals(people.size(),returnedPeople.size(),'Incorrect number of records returned');
        Test.stopTest();

    }
}