@isTest
private class PhoneValidationTest {
    @isTest static void validate_personCreationWithPhone_phoneValid() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='+381604009911';
        Test.setMock(HttpCalloutMock.class, new PhoneValidationAPIMock());
        Test.startTest();
        insert p;
        Test.stopTest();

        List<Phone_Validation_Result__c> valResults = [select FIELDS(ALL) from Phone_Validation_Result__c where Person__c=:p.Id];
        //kad budemo imali i mobile phone??? nije prob, ovde svakako ubacujemo samo phone
        System.assert(valResults.size()==1, 'Exactly one phone validation result should have been created for new user, not '+valResults.size());
        Phone_Validation_Result__c res = valResults[0];
        System.assertEquals(p.Phone__c, res.PhoneNumber__c, 'Inserted phone number does not match up with person phone');
        System.assertEquals(p.Id, res.Person__c, 'Inserted person id does not match up with owner or is empty');
        System.assertEquals(null, res.API_Error__c, 'API error field should be empty on success');
        System.assertEquals(381, res.CountryPrefix__c, 'Country prefix does not match expected value');
        System.assertEquals(null, res.ErrorId__c, 'Error id should be empty on success');
        //letnji dan do podne.... A way of quickly mapping to dto, to json, then directly comparing json??
        // But then there isn't informstion about specific fields
        //Just make sure that all relevant ones are populated/not populated???

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