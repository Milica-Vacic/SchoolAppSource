trigger PersonUpsertTrigger on SOBJECT (before insert, before update) {
private static Boolean alreadyValidated=false;

if (alreadyValidated || Trigger.new[0].Phone__c.isBlank() || Trigger.new[0].Phone__c==Trigger.old?.get(0).Phone__c){
    return;
}
alreadyValidated=true;
PhoneValidCallout.makeCallout(Trigger.new[0].Id,Trigger.new[0].Phone__c.toString(),'Phone__c');
}