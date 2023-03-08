({
    init : function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordTypeId",pageRef.state.c__recordTypeId);
    },

    handleSubmit : function(cmp, event, helper) {
        event.preventDefault();
        const fields = event.getParam('fields');
        if (fields.Phone__c) fields.Phone__c='+381'+fields.Phone__c;
        cmp.find('createPersonForm').submit(fields);
    },

    handleSuccess : function(cmp, event, helper) {
/*         event.preventDefault();
        var titleMessage="Person {0} {1} Created";
        var fields=cmp.find('createPersonForm').get("v.fields");
        titleMessage.replace("{0}",) */

        cmp.find('notifLib').showToast({
            "variant": "success",
            "title": "Person "+event.getParam("fields").Name.value+" Created",
            "message": "Record ID: " + event.getParam("id")
        });

        cmp.find("navigationService").navigate({ 
            "type": "standard__component",
            "attributes": {
                "componentName": "c__personDetailsView",
            },
                state:{
                    "c__recordTypeId":cmp.get("v.recordTypeId"),
                    "c__recordId":event.getParam("id")
                }    
            })
        }
})
