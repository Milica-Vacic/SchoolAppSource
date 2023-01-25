public with sharing class PhoneValidationAPI {
    private static PhoneValidationAPI instance = null;
    private PhoneValidationAPI(){}

    public static PhoneValidationAPI getInstance(){
           if(instance == null){
              instance = new PhoneValidationAPI();
            }
        return instance;
    }

    private Phone_Validation_Result__c mapToSObject(HttpResponse res){
        PhoneValidationResultDTO dto = PhoneValidationResultDTO.parse(res.getbody());
        Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
        ///stuff here, add if error to do less actions? or just map all of it???????????????????????????
        return validRes;
    }

    @future(callout=true)
    public static void validate(ID personId, String newPhone, String fieldName) {
        HttpRequest request = new HttpRequest();
        ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');
        String endpoint = '{0}?Key={1}&Phone={2}';
        endpoint=String.format(endpoint,new List<String>{mdt?.URL__c, mdt?.APIToken__c, newPhone});
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse res = new HTTP().send(request);    

        if (res.getStatusCode()==200){
            insert mapToSObject(res);
        }
        else{
            /* Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
            validRes.APIFaliure__c=res.getBody();
            insert validRes; */
            //add a textarea on sobject to store the whole body of the response if it happens
        }

    }
}