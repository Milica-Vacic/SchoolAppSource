@isTest
private class ValidationCalloutTest {
    @isTest static void personCreationTest() {
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
        //problem if another test creates more phone validation results??????
        System.assert([select Name from Phone_Validation_Result__c where Person__c=:p.Id limit 1]!=null, 'The Phone Validation Result was not created');

    }

    @isTest static void personErrorUpdateTest() {
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