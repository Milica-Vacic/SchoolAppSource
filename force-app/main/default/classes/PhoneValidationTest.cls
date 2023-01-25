@isTest
private class PhoneValidationTest {
    @isTest static void validate_personCreationWithPhone_phoneValid() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='+381604009911';

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PhoneValidationSuccess');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        insert p;
        Test.stopTest();
        System.assert([select Name from Phone_Validation_Result__c where Person__c=:p.Id limit 1]!=null, 'The Phone Validation Result was not created');
    }

    //person created wrong phone
    //person created no phone
    //person updated, but phone same
    //multiple records inserted simultanuously
    //triggering personUpsert twice in the same execution context? same context between start and end test??
    //dto test

    //wether 2 records of corect content
    @isTest static void validate_updateToInvalidPhone_phoneInvalid() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PhoneValidationSuccess');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        insert p;
        mock.setStaticResource('PhoneValidationError');
        p.Phone__c='';

        Test.startTest();
        update p;
        Test.stopTest();

        System.assert([select Name from Phone_Validation_Result__c where Person__c=:p.Id limit 1]!=null, 'The Phone Validation Result was not created');

    }
}