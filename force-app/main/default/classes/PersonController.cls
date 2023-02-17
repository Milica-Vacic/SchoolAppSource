public with sharing class PersonController {
    
    public static List<Person__c> getPersonList() {
        List<Person__c> people= [SELECT Name, Phone__c, Email__c, RecordType.Name FROM Person__c];
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPSERTABLE,people);
        return decision.getRecords();                    
    }

    @AuraEnabled(cacheable=true)
    public static List<PersonWithRecordTypeName> getPersonWithRecordTypeList(){
        List<PersonWithRecordTypeName> pWithType=new List<PersonWithRecordTypeName>();
        for(Person__c p: getPersonList()){
            pWithType.add(new PersonWithRecordTypeName(p));
        }
        return pWithType;
    }
    
    }