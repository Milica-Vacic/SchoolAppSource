public with sharing class PersonController {

    @AuraEnabled(cacheable=true)
    public static List<Person__c> getPersonList(String searchKey, Integer limitSize, Integer offset) {
        if (searchKey==null) searchKey='';
        searchKey=searchKey.trim();

        offset=Integer.valueOf(offset);
        if (offset==null || offset<0) offset=0;

        limitSize=Integer.valueOf(limitSize);
        if (limitSize==null) limitSize=2000;
        else if (limitSize<=0) limitSize=1;

        String key = '%' + searchKey + '%';
        List<Person__c> people= [
            SELECT 
            Name, Phone__c, Email__c, RecordType.Name FROM Person__c 
            WHERE
            Name LIKE :key OR Phone__c LIKE :key OR Email__c LIKE :key
            LIMIT :limitSize
            OFFSET :offset
            ];
        SObjectAccessDecision stripped = Security.stripInaccessible(AccessType.READABLE,people);
        return stripped.getRecords();                    
    }
    
    }