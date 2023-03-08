public with sharing class PersonDataManipulationService {
    public List<Person__c> getPeople(String searchKey, Integer limitSize, Integer offset) {
        String queryString='SELECT Name, Phone__c, Email__c, RecordType.Name FROM Person__c';

        Map<String, Object> varBinds = new Map<String, Object>();
        if (!String.isBlank(searchKey)){
            varBinds.put('searchKey', ('%' + searchKey + '%'));
            queryString+=' WHERE Name LIKE :searchKey OR Phone__c LIKE :searchKey OR Email__c LIKE :searchKey';
        }

        if (limitSize!=null && limitSize>0){
            varBinds.put('limitSize', limitSize);
            queryString+=' LIMIT :limitSize';
        }

        if (offset!=null && offset>0){
            varBinds.put('offset', offset);
            queryString+=' OFFSET :offset';
        }

        return Database.queryWithBinds(queryString, varBinds, AccessLevel.SYSTEM_MODE);                  
    }

    public List<RecordType> getRecordTypes() {
        return [
            SELECT Id, Name 
            FROM RecordType 
            WHERE SobjectType='Person__c'];                 
    }
}