trigger PersonTrigger on Person__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
    PersonTriggerLogicWrapper logicWrapper=new PersonTriggerLogicWrapper();
    logicWrapper.decideActions();
}