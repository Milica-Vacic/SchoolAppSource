public with sharing class PersonUpsertLogicWrapper {
    private static Boolean alreadyValidated=false;

    public void validatePhoneOnce(Person__c newRec, Person__c oldRec, List<String> fieldsToValidate){
        if (alreadyValidated) return;
        for(String field:fieldsToValidate){
            if (!String.isBlank((String)newRec.get(field)) && !(newRec.get(field)==oldRec?.get(field))){
                PhoneValidationAPI.validate(newRec.Id,(String)newRec.get(field),field);
            }
        }
        alreadyValidated=true;
    }


}