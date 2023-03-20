public with sharing class PersonCtrlExtension {
    public Person__c person{get;set;}
    public ApexPages.StandardController ctrl{get; set;}
    private static String recTypeId=ApexPages.currentPage().getParameters().get('RecordType');
    private static String recId=ApexPages.currentPage().getParameters().get('Id');

    
    public PersonCtrlExtension(ApexPages.StandardController controller) {
        ctrl=controller;
        if (!Test.isRunningTest()) ctrl.addFields(getLayoutFields());
        person = (Person__c) ctrl.getRecord();
        if (person.Id==null){
            person = (Person__c)Person__c.sObjectType.newSObject(recTypeId, true);
        }
    }

    public static List<String> getLayoutFields(){
        List<String> fields= new List<String>();
        String type;
        if (recId!=null)
            type= [SELECT RecordType.Name 
                    FROM Person__c
                    WHERE id=:recId][0].RecordType.Name;
        else 
            type= [SELECT Name 
                    FROM RecordType
                    WHERE id=:recTypeId][0].Name;

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

    public PageReference save() {
        PageReference secondPage;
        if (recId==null && person.Phone__c!=null) person.Phone__c='+381'+person.Phone__c;
        try{
            upsert person;
            secondPage = Page.PersonDetailsVF;
            secondPage.getParameters().put('Id',person.Id);
            secondPage.getParameters().put('Action',ApexPages.currentPage().getUrl().startsWithIgnoreCase(Page.PersonEditVF.getUrl()) ? 'edited' : 'saved');
            secondPage.setRedirect(true);
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

        return secondPage;
    }

}