({
    init: function (cmp, event, helper) {
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ]

        cmp.set('v.columns', [
            {
                label: 'Name',
                fieldName: 'NameUrl',
                type: 'url',
                typeAttributes: {label: { fieldName: 'Name' },
                target: '_blank'},
            },
            {
                label: 'Email',
                fieldName: 'Email__c',
                type: 'email'
            },
            {
                label: 'Phone',
                fieldName: 'Phone__c',
                type: 'phone'
            },
            {
                label: 'Record Type',
                fieldName: 'Type',
                type: 'Text'
            },
            {
                type: 'action',
                typeAttributes: { rowActions: actions }
            }
        ]);

        var action = cmp.get("c.getPersonList");
        action.setParams({});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.NameUrl = '/' + record.Id;
                    record.Type=record.RecordType.Name;
                });
                cmp.set('v.people', records)
            }
        });
        $A.enqueueAction(action);

    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'edit':
                helper.LightningConfirm.open({
                    message: `Edit person ${row.Name}?`,
                    theme: 'default',
                    label: 'Confirm',
                }).then(function(result) {
                    if (result) helper.navToEdit(cmp,row.Id);
                });
                break;
            case 'delete':
                helper.LightningConfirm.open({
                    message: `Delete person ${row.Name}?`,
                    theme: 'default',
                    label: 'Confirm',
                }).then(function(result) {
                    if (result) helper.handlePersonDelete(cmp,row);
                });
        }
    },

    handlePersonCreate : function (cmp, event, helper) {
        cmp.find("navigationService").navigate({ 
            "type": "standard__component",
            "attributes": {
                "componentName": "c__selectPersonTypeAura"    
            },

        });
    },

})
