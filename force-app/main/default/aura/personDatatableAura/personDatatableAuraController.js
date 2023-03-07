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
                //TO BE ADDED
                break;
            case 'delete':
                //helper.removeBook(cmp, row);
                //TO BE ADDED
                break;
        }
    },

    handlePersonCreate : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
        //TO BE ADDED
    }
})
