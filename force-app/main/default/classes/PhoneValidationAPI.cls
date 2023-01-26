public with sharing class PhoneValidationAPI {
    private static PhoneValidationAPI instance = null;
    private PhoneValidationAPI(){}
/*     public static PhoneValidationAPI getInstance(){
           if(instance == null){
              instance = new PhoneValidationAPI();
            }
        return instance;
    } */

    private static Phone_Validation_Result__c mapToSObject(HttpResponse res){
        PhoneValidationResultDTO dto = PhoneValidationResultDTO.parse(res.getbody());
        PhoneValidationResultDTO.Items item=dto.Items[0];
        Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Phone_Validation_Result__c');
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
            for (Schema.SObjectField field : fieldMap.values()) {
                if (item.get(field.getDescribe().getName().remove('__c'))!=null && field.getDescribe().isUpdateable()){
                    validRes.put(field.getDescribe().getName(), item.get(field.getDescribe().getName().remove('__c')));
                }
            }
        validRes.ErrorId__c=(Decimal)item.get('Id');
        return validRes;
    }

    @future(callout=true)
    public static void validate(ID personId, String newPhone, String fieldName) {
        HttpRequest request = new HttpRequest();
        ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');
        String endpoint = '{0}?Key={1}&Phone={2}';
        endpoint=String.format(endpoint,new List<String>{mdt?.URL__c, mdt?.APIToken__c, EncodingUtil.urlEncode(newPhone, 'ASCII')});
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse res = new HTTP().send(request);  
        Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
        if (res.getStatusCode()==200){
            validRes= mapToSObject(res);
        }
        else{
            validRes.API_Error__c=res.getBody();
        }
        validRes.Person__c=personId;
        validRes.ValidatedFieldName__c=fieldName;
        validRes.ValidatedFieldValue__c=newPhone;
        System.debug(validRes);
        insert validRes;

    }
}