trigger PersonUpsertTrigger on Person__c (after insert, before update) {
    
    PersonUpsertLogicWrapper logicWrapper=new PersonUpsertLogicWrapper();
    List<String> fieldsToValidate = new List<String>{'Phone__c'};
    logicWrapper.validatePhoneOnce(Trigger.New[0], Trigger.old?.get(0), fieldsToValidate);
}