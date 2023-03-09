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
    }
})
