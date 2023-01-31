public with sharing class PersonUpsertLogicWrapper {
    private static Boolean alreadyValidated=false;
    private static Boolean alreadyConcated=false;
    private  static List<String> fieldsToValidate = new List<String>{'Phone__c', 'Work_Phone__c'};
    @TestVisible public static Boolean validateMultiple=false;
    @TestVisible public static Boolean skipTrigger=false;

    public void validatePhoneOnce(Person__c newRec, Person__c oldRec){
        if (skipTrigger || (alreadyValidated && !validateMultiple)) return;
        for(String field:fieldsToValidate){
            if (!String.isBlank((String)newRec.get(field)) && !(newRec.get(field)==oldRec?.get(field))){
                PhoneValidationAPI.validate(newRec.Id,(String)newRec.get(field),field, newRec.Country__c);
            }
        }
        alreadyValidated=true;
    }

    public void concatFullName(List<Person__c> newRecs, Map<Id,Person__c> oldRecs){
        if (alreadyConcated) return;
        for (Person__c newRec:newRecs){
            if ((oldRecs!=null &&(newRec.First_Name__c!=oldRecs?.get(newRec.Id).First_Name__c || newRec.Last_Name__c!=oldRecs?.get(newRec.Id).Last_Name__c)) || oldRecs==null){
                String fullNAme=String.format('{0} {1}', new List<String>{newRec.First_Name__c, newRec.Last_Name__c});
                newRec.Name=fullNAme;
            }
        }
        alreadyConcated=true;

    }


}