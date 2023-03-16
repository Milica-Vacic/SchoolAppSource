public with sharing class PopupController {
    public Boolean isVisible {get; set;}
    public Person__c person {get;set;}
    public ApexPages.StandardSetController controller {get;set;}

    public PopupController(ApexPages.StandardSetController controller){
        isVisible=false;
        person=(Person__c)controller.getRecord();
        this.controller=controller;
    }

    public void closePopup() {        
        isVisible = false;     
    }     
    
    public void showPopup() {        
        isVisible = true;
    }

    public void confirmPopup() {        
        isVisible = false;

        try{
            delete person;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record succesfully deleted'));  
            this.getPeople();
        }
        catch(DmlException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }

    }

    public List<Person__c> getPeople(){
        return controller.getRecords();
    }
}