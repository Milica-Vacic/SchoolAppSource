public with sharing class PhoneValidationAPI {
    private static PhoneValidationAPI instance = null;
    private PhoneValidationAPI(){}

    public static PhoneValidationAPI getInstance(){
           if(instance == null){
              instance = new PhoneValidationAPI();
            }
        return instance;
    }

    @future(callout=true)
    public void validate(ID personId, String newPhone, String fieldName) {
        HttpRequest request = new HttpRequest();
        ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');
        String endpoint = '{0}?Key={1}&Phone={2}';
        endpoint=String.format(endpoint,new List<String>{mdt?.URL__c, mdt?.KeyValue__c, newPhone});
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse res = new HTTP().send(request);    

        if (res.getStatusCode()==200){
            Map<string,object> m = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
            List<Object> items = (List<Object>)m.get('Items');
            m = (Map<String, Object>)items[0];
            Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
            validRes.ValidatedFieldValue__c=newPhone;
            validRes.ValidatedFieldName__c=fieldName; //Is this dumb????????
            validRes.Person__c=personId;
            if (m.get('Error')==null){
                validRes.PhoneNumber__c=(String)m.get('PhoneNumber');
                validRes.RequestProcessed__c=(Boolean)m.get('RequestProcessed');
                validRes.IsValid__c=(String)m.get('IsValid');
                validRes.NetworkCode__c=(String)m.get('NetworkCode');
                validRes.NetworkName__c=(String)m.get('NetworkName');
                validRes.NetworkCountry__c=(String)m.get('NetworkCountry');
                validRes.NationalFormat__c=(String)m.get('NationalFormat');
                validRes.CountryPrefix__c=(Integer)m.get('CountryPrefix');
                validRes.NumberType__c=(String)m.get('NumberType');
            }
            else{
                validRes.ErrorId__c=(Integer)m.get('Id');
                validRes.Error__c=(String)m.get('Error');
                validRes.ErrorCause__c=(String)m.get('Cause');
                validRes.ErrorResolution__c=(String)m.get('Resolution');
            }
            insert validRes;
        }
        else{
            System.debug(res.getStatus());
        }

    }
}