({
    init: function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordTypeId",pageRef.state.recordTypeId);
    },

    pageRefChange: function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordTypeId",pageRef.state.recordTypeId);
        $A.get('e.force:refreshView').fire();
    }
})