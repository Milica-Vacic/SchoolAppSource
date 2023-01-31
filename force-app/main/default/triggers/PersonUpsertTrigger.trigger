trigger PersonUpsertTrigger on Person__c (before insert, after insert, before update) {
    PersonUpsertLogicWrapper logicWrapper=new PersonUpsertLogicWrapper();

    if (Trigger.isBefore) {
        logicWrapper.concatFullName(Trigger.New, Trigger.oldMap);
        if (Trigger.isUpdate){
            logicWrapper.validatePhoneOnce(Trigger.New[0], Trigger.old?.get(0));
        }
    }
    else logicWrapper.validatePhoneOnce(Trigger.New[0], Trigger.old?.get(0));



}