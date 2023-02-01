public with sharing class PersonTriggerLogicWrapper {

    private static Boolean alreadyValidated=false;
    private final static List<String> FIELDS_TO_VALIDATE = new List<String>{'Phone__c', 'Work_Phone__c'};
    @TestVisible public static Boolean skipTrigger=false;
    @TestVisible public static Boolean skipPhoneValidation=false;
    @TestVisible public static Boolean skipFullNameConcat=false;
    @TestVisible public static Boolean validateMultiple=false;
    @TestVisible public static Integer hasConcatedCount=0;

    public void decideActions(){
        if (skipTrigger) return;
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                concatFullName((List<Person__c>)Trigger.New, (Map<Id,Person__c>)Trigger.oldMap);		
            }
            when AFTER_INSERT {	
                validatePhoneOnce((Person__c)Trigger.New[0], (Person__c)Trigger.old?.get(0));
            }	
            when BEFORE_UPDATE {	
                concatFullName((List<Person__c>)Trigger.New, (Map<Id,Person__c>)Trigger.oldMap);
                validatePhoneOnce((Person__c)Trigger.New[0], (Person__c)Trigger.old?.get(0));	
            }		
        }
    }

    public void validatePhoneOnce(Person__c newRec, Person__c oldRec){
        if (skipPhoneValidation||alreadyValidated) return;
        for(String field:FIELDS_TO_VALIDATE){
            if (!String.isBlank((String)newRec.get(field)) && !(newRec.get(field)==oldRec?.get(field))){
                PhoneValidationAPI.validate(newRec.Id,(String)newRec.get(field),field, newRec.Country__c);
            }
        }
        if (!validateMultiple) alreadyValidated=true;
    }

    public void concatFullName(List<Person__c> newRecs, Map<Id,Person__c> oldRecs){
        if (skipFullNameConcat) return;
        for (Person__c newRec:newRecs){
            if ((oldRecs!=null &&(newRec.First_Name__c!=oldRecs?.get(newRec.Id).First_Name__c || newRec.Last_Name__c!=oldRecs?.get(newRec.Id).Last_Name__c)) || oldRecs==null){
                String fullNAme=String.format('{0} {1}', new List<String>{newRec.First_Name__c, newRec.Last_Name__c});
                newRec.Name=fullNAme;
                if (Test.isRunningTest()) hasConcatedCount+=1;
            }
        }


    }


}