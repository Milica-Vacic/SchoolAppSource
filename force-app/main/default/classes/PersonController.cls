public with sharing class PersonController {

    @AuraEnabled(cacheable=true)
    public static List<Person__c> getPersonList() {
        List<Person__c> people= [SELECT Name, Phone__c, Email__c, RecordType.Name FROM Person__c];
        SObjectAccessDecision stripped = Security.stripInaccessible(AccessType.READABLE,people);
        return stripped.getRecords();                    
    }

    @AuraEnabled(cacheable=true)
    public static List<RecordType> getPersonRecordTypeList(){
        return [select Name, Id from RecordType where SobjectType='Person__c'];
    }
    
    }