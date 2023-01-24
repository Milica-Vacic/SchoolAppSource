trigger PersonUpsertTrigger on Person__c (after insert, before update) {
private static Boolean alreadyValidated=false;

if (!alreadyValidated && !(String.isBlank(Trigger.new[0].Phone__c)) && !(Trigger.new[0].Phone__c==Trigger.old?.get(0).Phone__c)){
    alreadyValidated=true;
    PhoneValidCallout.makeCallout(Trigger.new[0].Id,Trigger.new[0].Phone__c,'Phone__c'); //hardcoding api field name???
}

}