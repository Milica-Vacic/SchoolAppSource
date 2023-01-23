public with sharing class PhoneValidCallout {
        @future(callout=true)
        public static void makeCallout(ID personId, String newPhone, String fieldName) {
            HttpRequest request = new HttpRequest();
            ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');//zauzima heap space???
            String endpoint = mdt?.URL__c+'?Key='+mdt?.KeyValue__c+'&Phone='+newPhone;
            System.debug(endpoint);
            request.setEndPoint(endpoint);
            request.setMethod('GET');
            HttpResponse res = new HTTP().send(request);
            Map<string,object> m = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
            Phone_Validation_Result__c validRes=new Phone_Validation_Result__c();
            validRes.ValidatedFieldValue__c=newPhone;
            validRes.ValidatedFieldName__c=fieldName; //Is this dumb????????
            validRes.Person__c=personId;
            if (res.getStatusCode()==200){
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