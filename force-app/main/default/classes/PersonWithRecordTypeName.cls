public with sharing class PersonWithRecordTypeName {
    @AuraEnabled public Id Id;
    @AuraEnabled public String Name;
    @AuraEnabled public String Phone;
    @AuraEnabled public String Email;
    @AuraEnabled public String RecordType;
    @AuraEnabled public String NameUrl;

    public PersonWithRecordTypeName(Person__c p) {
        this.Id=p.Id;
        this.Name=p.Name;
        this.Phone=p.Phone__c;
        this.Email=p.Email__c;
        this.RecordType=p.RecordType.Name;
        this.NameUrl='/'+p.Id;
    }

}