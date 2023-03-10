({
    navToEdit : function (cmp,recId) {
        cmp.find("navigationService").navigate({ 
            "type": "standard__component",
            "attributes": {
                "componentName": "c__personEditView"    
            },
            state:{
                "c__recordId":recId,
            }    

        });
    },

    handlePersonDelete : function (cmp,row) {
        var deletion = cmp.get("c.deletePerson");
        deletion.setParams({'person':row});
        deletion.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Person Deleted",
                    "message": "Record ID: " +row.Id
                });
                var people = cmp.get('v.people');
                var rowIndex = people.indexOf(row);
                people.splice(rowIndex, 1);
                cmp.set('v.people', people);
            }
            else{
                cmp.find('notifLib').showToast({
                    "variant": "error",
                    "title": "Person Deletion Failed",
                    "message": "Record ID: " +row.Id
                });
            }
        });
        $A.enqueueAction(deletion);
    }, 
})
