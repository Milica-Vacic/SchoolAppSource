({
    init : function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordTypeId",pageRef.state.c__recordTypeId);
        component.set("v.recordId",pageRef.state.c__recordId);
    },
})
