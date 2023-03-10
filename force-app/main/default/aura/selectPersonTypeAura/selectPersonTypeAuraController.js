({

    init: function (cmp, event, helper) {
        var action = cmp.get("c.getPersonRecordTypes");
        action.setParams({});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                cmp.set('v.types', records)
            }
        });
        $A.enqueueAction(action);

    },

    handleRecTypeSelected : function(cmp, event, helper) {
        var type=cmp.find("personTypeSelect").get("v.value");
        cmp.find("navigationService").navigate({ 
            "type": "standard__component",
            "attributes": {
                "componentName": "c__personCreateView",
            },
                state:{
                    "c__recordTypeId":type,
                }    
            })
        }
})
