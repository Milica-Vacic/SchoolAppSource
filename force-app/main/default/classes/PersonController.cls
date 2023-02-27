public with sharing class PersonController {

    @AuraEnabled(cacheable=true)
    public static List<Person__c> getPersonList(String searchKey) {
        //TODO check if search key haas any value at all
        //TODO implement the pagination here
        String key = '%' + searchKey + '%';
        List<Person__c> people= [
            SELECT Name, Phone__c, Email__c, RecordType.Name FROM Person__c WHERE
            Name LIKE :key OR Phone__c LIKE :key OR Email__c LIKE :key];
        SObjectAccessDecision stripped = Security.stripInaccessible(AccessType.READABLE,people);
        return stripped.getRecords();                    
    }
    
    }