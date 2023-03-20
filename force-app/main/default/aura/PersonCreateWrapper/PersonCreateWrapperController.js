({
    onPageReferenceChange: function(component, event, helper) {
        var pageRef=component.get("v.pageReference");
        component.set("v.recordTypeId",pageRef.state.recordTypeId);
    }
})