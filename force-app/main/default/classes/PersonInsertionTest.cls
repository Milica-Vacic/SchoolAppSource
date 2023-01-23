@isTest
private class PersonInsertionTest {
    @isTest static void validationRecordCreationTest() {
        Person__c p=new Person__c();
        p.First_Name__c='fn2';
        p.Last_Name__c='ln2';
        p.Email__c='fn2ln2@gmail.com';
        p.Phone__c='+381604009911';

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PhoneValidationSuccess.json');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        //HttpResponse result = PhoneValidCallout.makeCallout(personId, newPhone, fieldName)
        // Verify mock response is not null
        //System.assertNotEquals(null,result, 'The callout returned a null response.');
        // Verify status code
        //System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
        //System.assertEquals('application/json;charset=UTF-8',
         // result.getHeader('Content-Type'),
          //'The content type value is not expected.');  
        // Verify the array contains 3 items     
        //Map<String, Object> results = (Map<String, Object>) 
            //JSON.deserializeUntyped(result.getBody());
        //List<Object> animals = (List<Object>) results.get('animals');
        //System.assertEquals(3, animals.size(), 'The array should only contain 3 items.');          
        Test.startTest();
        //Database.SaveResult result = Database.insert(p, false);
        insert p;
        Test.stopTest();
        System.assert([select ValidatedFieldValue__c from Phone_Validation_Result__c where Person__c=:p.Id].size() > 0,'Phone Validation Result was not created');


    }
}