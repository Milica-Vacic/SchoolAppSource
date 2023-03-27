@IsTest
public with sharing class LwcUtilityTest {
    private static String successBody='{"Items":[{"PhoneNumber":"{0}","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"+381","NetworkName":"A1",'
    +'"NetworkCountry":"{1}","NationalFormat":"0604009911","CountryPrefix":381,"NumberType":"MOBILE"}] }';
    private static Map<String,String> headers= new Map<String,String>{'Content-Type'=>'application/json;charset=UTF-8'};

    @isTest
    static void validatePhone_withoutCountry_ReturnValueIsParsableToDTO() {
        String phone='0604009911';
        String body=successBody.replace('{0}', phone);
        body=body.replace('{1}', (String)(((ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default'))?.DefaultCountry__c));
        Test.setMock(HttpCalloutMock.class, new APIMock(200,headers,body));

        Test.startTest();
        String val=LwcUtility.validatePhone(phone, null);
        Test.stopTest();
        try{
            PhoneValidationResultDTO dto = PhoneValidationResultDTO.parse(val);
        }
        catch(Exception e){
            System.Assert(false, 'Result should be mappable to PhoneValidationResultDTO, but mapping resulted in an error');
        }      
    }
}
