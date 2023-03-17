public with sharing class PersonController {

    public Person__c person{get;set;}
    public ApexPages.StandardController ctrl{get; set;}
    
    public PersonController(ApexPages.StandardController controller) {
        ctrl=controller;
        ctrl.addFields(getLayoutFields());
        person = (Person__c) ctrl.getRecord();
    }

    public static List<String> getLayoutFields(){
        List<String> fields= new List<String>();
        Id id=ApexPages.currentPage().getParameters().get('id');
        String type = [select RecordType.Name from Person__c where id=:id][0].RecordType.Name;

        List<Metadata.Metadata> layouts = type=='Tutor'?
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Person__c-Tutor_Layout'}):
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Person__c-Person Layout'});

        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        if (item.behavior!=Metadata.UiBehavior.Readonly && item.field!='Name') fields.add(item.field);
                    }
                }
            }
        }
        return fields;
    }

/*     public Person__c getNewPerson(){
        Person__c newPerson=new Person__c();
        String type=ApexPages.currentPage().getParameters().get('Type');
        newPerson.RecordTypeId=Schema.SObjectType.Person__c.getRecordTypeInfosByName().get(type).getRecordTypeId();
        return newPerson;
    } */

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

/*     public PersonController getSelf(){
        return this;
    } */
    
/*     public void delPerson(){
        delete person;
    } */


    public PageReference save() {
        PageReference secondPage;
        try{
            ctrl.save();
            secondPage = Page.PersonDetailsVF;
            secondPage.getParameters().put('Id',person.Id);
            system.debug(ApexPages.currentPage().getUrl());
            system.debug(Page.PersonEditVF.getUrl());
            secondPage.getParameters().put('Action',ApexPages.currentPage().getUrl().startsWithIgnoreCase(Page.PersonEditVF.getUrl()) ? 'edited' : 'saved');
            secondPage.setRedirect(true);
        }
        catch(DmlException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

        return secondPage;
    }



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