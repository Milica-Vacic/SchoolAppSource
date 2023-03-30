global with sharing class PhoneFieldPicklist extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;

    public PhoneFieldPicklist(VisualEditor.DesignTimePageContext context) {
        this.context = context;
    }

    global override VisualEditor.DataRow getDefaultValue(){
        return this.getValues()?.get(0);
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  rows = new VisualEditor.DynamicPickListRows();

        SObjectType objectType = Schema.getGlobalDescribe().get(context.entityName);
        Map<String,Schema.SObjectField> fields = objectType.getDescribe().fields.getMap();
        for(String fname:fields.keySet()){
            if (fields.get(fname).getDescribe().getType()==Schema.displayType.PHONE){
                VisualEditor.DataRow row = new VisualEditor.DataRow(fields.get(fname).getDescribe().getLabel(), fname);
                rows.addRow(row);
            }
        }
        return rows;
    }
}