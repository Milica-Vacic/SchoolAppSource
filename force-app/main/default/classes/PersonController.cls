public with sharing class PersonController {

    @AuraEnabled(cacheable=true)
    public static List<Person__c> getPersonList(String searchKey, Integer limitSize, Integer offset) {
        PersonDataManipulationService pdms = new PersonDataManipulationService();
        List<Person__c> people = pdms.getPeople(searchKey, limitSize, offset);
        SObjectAccessDecision stripped = Security.stripInaccessible(AccessType.READABLE,people);
        return stripped.getRecords();                    
    }
    
    }