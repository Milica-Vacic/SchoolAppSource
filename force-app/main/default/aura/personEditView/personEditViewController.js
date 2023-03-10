({
    init : function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordId",pageRef.state.c__recordId);
    },

    handleSuccess : function(cmp, event, helper) {
        cmp.find('notifLib').showToast({
            "variant": "success",
            "title": "Person "+event.getParam("fields").Name.value+" Edited",
            "message": "Record ID: " + event.getParam("id")
        });

        cmp.find("navigationService").navigate({ 
            "type": "standard__component",
            "attributes": {
                "componentName": "c__personDetailsView",
            },
                state:{
                    "c__recordId":event.getParam("id")
                }    
            })
        }
})
