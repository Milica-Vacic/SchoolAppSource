public with sharing class PhoneValidCallout {
    public PhoneValidCallout() {
        @future(callout=true)
        public static void makeCallout(ID personId, String newPhone, String fieldName) {
            HttpRequest request = new HttpRequest();
            String endpoint = ValidationAPISettings__mdt.getInstance('default').URL__c+'?Key='+ValidationAPISettings__mdt.getInstance('default').KeyValue__c+'&Phone='+newPhone;
            request.setEndPoint(endpoint);
            request.setMethod('GET');
            HttpResponse res = new HTTP().send(request);
            Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
            validRes.ValidatedFieldValue=newPhone;
            validRes.ValidatedFieldName=fieldName; //Is this dumb????????
            validRes.Person__c=personId;
            if (res.getStatusCode()==200){
                Map<string,object> m = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
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

    }
}
