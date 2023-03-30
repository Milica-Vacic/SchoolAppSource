@isTest
private class PhoneValidationTest {
    private static String successBody='{"Items":[{"PhoneNumber":"{0}","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"+381","NetworkName":"A1",'
            +'"NetworkCountry":"{1}","NationalFormat":"0604009911","CountryPrefix":381,"NumberType":"MOBILE"}] }';
    private static String errorBody='{"Items":[{"Id":1002,"Error":"Invalid phone number format","Cause":"The phone number provided is not in a valid international format.","Resolution":"Please ensure that you supply a phone number and try again."}]}';
    private static Map<String,String> headers= new Map<String,String>{'Content-Type'=>'application/json;charset=UTF-8'};

    @isTest static void validatePerson_personCreationWithPhone_phoneValid() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='+381604009911';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        Test.stopTest();

        List<Phone_Validation_Result__c> valResults = [select ValidatedFieldName__c, ValidatedFieldValue__c, PhoneNumber__c,
            RequestProcessed__c,IsValid__c, NetworkCode__c, NetworkName__c, NetworkCountry__c, NationalFormat__c, CountryPrefix__c, 
            NumberType__c, ErrorId__c, Cause__c, Error__c, Resolution__c, API_Error__c
            from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(1, valResults.size(), 'Exactly one phone validation result should have been created for new user');
        Phone_Validation_Result__c res = valResults[0];
        System.assertEquals('Phone__c', res.ValidatedFieldName__c, 'Incorrect value on Phone Validation Result for ValidatedFieldName__c');
        System.assertEquals(p.Phone__c, res.ValidatedFieldValue__c, 'Incorrect value on Phone Validation Result for ValidatedFieldValue__c');
       
        System.assertEquals(p.Phone__c, res.PhoneNumber__c, 'Incorrect value on Phone Validation Result for PhoneNumber__c');
        System.assertEquals(true, res.RequestProcessed__c, 'Incorrect value on Phone Validation Result for RequestProcessed__c');
        System.assertEquals('Yes', res.IsValid__c, 'Incorrect value on Phone Validation Result for IsValid__c');
        System.assertEquals('+381', res.NetworkCode__c, 'Incorrect value on Phone Validation Result for NetworkCode__c');
        System.assertEquals('A1', res.NetworkName__c, 'Incorrect value on Phone Validation Result for NetworkName__c');
        ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');
        System.assertEquals(mdt?.DefaultCountry__c, res.NetworkCountry__c, 'Incorrect value on Phone Validation Result for NetworkCountry__c');
        System.assertEquals('0604009911', res.NationalFormat__c, 'Incorrect value on Phone Validation Result for NationalFormat__c');
        System.assertEquals(381, res.CountryPrefix__c, 'Incorrect value on Phone Validation Result for CountryPrefix__c');
        System.assertEquals('MOBILE', res.NumberType__c, 'Incorrect value on Phone Validation Result for NumberType__c');

        System.assertEquals(null, res.ErrorId__c, 'ErrorId__c should be null on succesful Phone Validation Result');
        System.assertEquals(null, res.Cause__c, 'Cause__c should be null on succesful Phone Validation Result');
        System.assertEquals(null, res.Error__c, 'Error__c should be null on succesful Phone Validation Result');
        System.assertEquals(null, res.Resolution__c, 'Resolution__c should be null on succesful Phone Validation Result');
        System.assertEquals(null, res.API_Error__c, 'API_Error__c should be null on succesful Phone Validation Result');
    }

    @isTest static void validatePerson_personCreationBadPhone_errorResult() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='abc';
        String body=errorBody;
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        Test.stopTest();

        List<Phone_Validation_Result__c> valResults = [select ValidatedFieldName__c, ValidatedFieldValue__c, PhoneNumber__c,
            RequestProcessed__c,IsValid__c, NetworkCode__c, NetworkName__c, NetworkCountry__c, NationalFormat__c, CountryPrefix__c, 
            NumberType__c, ErrorId__c, Cause__c, Error__c, Resolution__c, API_Error__c
            from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(1, valResults.size(), 'Exactly one phone validation result should have been created for new user');
        Phone_Validation_Result__c res = valResults[0];
        System.assertEquals('Phone__c', res.ValidatedFieldName__c, 'Incorrect value on Phone Validation Result for ValidatedFieldName__c');
        System.assertEquals(p.Phone__c, res.ValidatedFieldValue__c, 'Incorrect value on Phone Validation Result for ValidatedFieldValue__c');
    
        System.assertEquals(null, res.PhoneNumber__c, 'Incorrect value on Phone Validation Result for PhoneNumber__c');
        System.assertEquals(false, res.RequestProcessed__c, 'Incorrect value on Phone Validation Result for RequestProcessed__c');
        System.assertEquals(null, res.IsValid__c, 'Incorrect value on Phone Validation Result for IsValid__c');
        System.assertEquals(null, res.NetworkCode__c, 'Incorrect value on Phone Validation Result for NetworkCode__c');
        System.assertEquals(null, res.NetworkName__c, 'Incorrect value on Phone Validation Result for NetworkName__c');
        System.assertEquals(null, res.NetworkCountry__c, 'Incorrect value on Phone Validation Result for NetworkCountry__c');
        System.assertEquals(null, res.NationalFormat__c, 'Incorrect value on Phone Validation Result for NationalFormat__c');
        System.assertEquals(null, res.CountryPrefix__c, 'Incorrect value on Phone Validation Result for CountryPrefix__c');
        System.assertEquals(null, res.NumberType__c, 'Incorrect value on Phone Validation Result for NumberType__c');

        System.assertEquals(1002, res.ErrorId__c, 'ErrorId__c has incorrect value on bad Phone Validation Result');
        System.assertEquals('Invalid phone number format', res.Error__c, 'Error__c has incorrect value on bad Phone Validation Result');
        System.assertEquals('The phone number provided is not in a valid international format.', res.Cause__c, 'Cause__c has incorrect value on bad Phone Validation Result');
        System.assertEquals('Please ensure that you supply a phone number and try again.', res.Resolution__c, 'Resolution__c has incorrect value on bad Phone Validation Result');
        System.assertEquals(null, res.API_Error__c, 'API_Error__c should be null on bad Phone Validation Result');
    }

    @isTest static void validatePerson_personCreationNoPhone_noValidation() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        Test.startTest();
        insert p;
        Test.stopTest();

        List<Phone_Validation_Result__c> valResults = [select Name from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(0, valResults.size(), 'No phone validation results should have been created for new user');        
    }

    @isTest static void validatePerson_updateWithSamePhone_noValidation() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        insert p;
        p.First_Name__c='newName';
        Test.startTest();
        update p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select Name from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(1, valResults.size(), 'Exactly one phone validation result should have been created for new user');      

    }

    @isTest static void validatePerson_multiPersonCreation_singleValidation() {
        List<Person__c> people=TestDataFactory.createPeople('test', 5);
        for(Person__c p: people) p.Phone__c='0604009911';
        String body=successBody.replace('{0}', people[0].Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert people;
        Test.stopTest();
        Map<Id, Person__c> pmap = new Map<Id, Person__c>(people);
        List<Phone_Validation_Result__c> valResults = [select Person__c, Name from Phone_Validation_Result__c where Person__c in :pmap.keySet()];
        System.assertEquals(1, valResults.size(), 'Phone should have only been validated for a single user');
        System.assertEquals(people[0].Id, valResults[0].Person__c, 'Validated phone belongs to an incorrect person');      
    }

    @isTest static void validatePerson_multiTrigger_singleValidation() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        p.Phone__c='0604009915';
        update p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select PhoneNumber__c from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(1, valResults.size(), 'Exactly one phone validation result should have been created'); 
        System.assertEquals('0604009911', valResults[0].PhoneNumber__c, 'Validated phone should match first value');   
    }

    @isTest static void validatePerson_updatePhoneWithValidateMultipleTrue_twoValidations() {
        PersonTriggerLogicWrapper.validateMultiple=true;
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        insert p;
        p.Phone__c='0604009915';
        Test.startTest();
        update p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select Id from Phone_Validation_Result__c where Person__c=:p.Id order by CreatedDate asc];
        System.assertEquals(2, valResults.size(), 'Exactly two phone validation results should have been created');
    }

    @isTest static void validatePerson_createPersonWithCountry_newtworkCountryMatch() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        p.Country__c='USA';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', p.Country__c);
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select NetworkCountry__c from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(p.Country__c, valResults[0].NetworkCountry__c, 'Incorrect value on Phone Validation Result for NetworkCountry__c');  
    }

    @isTest static void validatePerson_noCountry_emptyCountry() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        PhoneValidationAPI.ValidationAPISettingsInstance='NoCountry';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', '');
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select NetworkCountry__c from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(null, valResults[0].NetworkCountry__c, 'Incorrect value on Phone Validation Result for NetworkCountry__c');  
    }

    @isTest static void validatePerson_createWith2Phones_validateBoth() {
        Person__c p=TestDataFactory.createPeople('test', 1)[0];
        p.Phone__c='0604009911';
        p.Work_Phone__c='0604009915';
        String body=successBody.replace('{0}', p.Phone__c);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));
        Test.startTest();
        insert p;
        Test.stopTest();
        List<Phone_Validation_Result__c> valResults = [select ValidatedFieldName__c, ValidatedFieldValue__c from Phone_Validation_Result__c where Person__c=:p.Id];
        System.assertEquals(2, valResults.size(), 'Exactly two phone validation results should have been created');
        for (Phone_Validation_Result__c result:valResults){
            System.assertEquals(p.get(result.ValidatedFieldName__c), result.ValidatedFieldValue__c, 'ValidatedFieldName__c and ValidatedFieldValue__c do not match up with person');  
        }

    }


}