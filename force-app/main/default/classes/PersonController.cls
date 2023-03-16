public with sharing class PersonController {

    public Person__c person {get; set;}
    
    public PersonController(ApexPages.StandardController controller) {
        person = (Person__c) controller.getRecord();
    }

    public Person__c getNewPerson(){
        Person__c newPerson=new Person__c();
        String type=ApexPages.currentPage().getParameters().get('Type');
        newPerson.RecordTypeId=Schema.SObjectType.Person__c.getRecordTypeInfosByName().get(type).getRecordTypeId();
        return newPerson;
    }

/*     public Person__c getTutor(){
        Person__c tutor=new Person__c();
        tutor.RecordTypeId=Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Tutor').getRecordTypeId();
        return tutor;
    }

    public Person__c getStudent(){
        Person__c student=new Person__c();
        student.RecordTypeId=Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        return student;
    } */

    public PersonController getSelf(){
        return this;
    }
    
    public void delPerson(){
        delete person;
    }

/* 
    public PageReference save() {
        PageReference secondPage;
        try{
            upsert person;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record succesfully saved'));  
            secondPage = Page.PersonDetailsVF;
            secondPage.setRedirect(true);
            secondPage.getParameters().put('Id',person.Id);   
        }
        catch(DmlException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

        return secondPage;
    } */



    @AuraEnabled(cacheable=true)
    public static List<Person__c> getPersonList(String searchKey, Integer limitSize, Integer offset) {
        PersonDataManipulationService pdms = new PersonDataManipulationService();
        List<Person__c> people = pdms.getPeople(searchKey, limitSize, offset);
        SObjectAccessDecision stripped = Security.stripInaccessible(AccessType.READABLE,people);
        return stripped.getRecords();                    
    }

    @AuraEnabled(cacheable=true)
    public static List<RecordType> getPersonRecordTypes() {
        PersonDataManipulationService pdms = new PersonDataManipulationService();
        return pdms.getRecordTypes();
    }

    @AuraEnabled
    public static void deletePerson(Person__c person) {
        if (person!=null) delete person;
    }
    
    
    }