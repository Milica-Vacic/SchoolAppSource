@IsTest
public with sharing class PhoneFieldPicklistTest {
    
    @IsTest
    static void getValues_PersonContext_ExpectedRowsReturned(){
        VisualEditor.DesignTimePageContext context= new VisualEditor.DesignTimePageContext();
        context.entityName='Person__c';
        PhoneFieldPicklist picklist= new PhoneFieldPicklist(context);

        Test.startTest();
        VisualEditor.DynamicPickListRows rows=picklist.getValues();
        Map<String, Schema.SObjectField> personFields = Schema.SObjectType.Person__c.fields.getMap();
        for (String fieldName : personFields.keySet()) {
            Schema.DescribeFieldResult fieldInfo = personFields.get(fieldName).getDescribe();
            if (fieldInfo.getType() == Schema.DisplayType.PHONE) {
                Boolean isContained=false;
                for(VisualEditor.DataRow row:rows.getDataRows()){
                    if (row.getValue()==fieldName && row.getLabel()==fieldInfo.getLabel()){
                        isContained=true;
                    }
                }
                System.Assert(isContained, fieldName +'was not contained in result in the expected format');
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void getDefaultValue_PersonContext_ReturnsFirstRow(){
        VisualEditor.DesignTimePageContext context= new VisualEditor.DesignTimePageContext();
        context.entityName='Person__c';
        PhoneFieldPicklist picklist= new PhoneFieldPicklist(context);

        Test.startTest();
        VisualEditor.DynamicPickListRows rows=picklist.getValues();
        VisualEditor.DataRow defaultRow=picklist.getDefaultValue();
        System.assertEquals(rows.get(0).getValue(), defaultRow.getValue(), 'Default row value should be first value of getValues()');
        System.assertEquals(rows.get(0).getLabel(), defaultRow.getLabel(), 'Default row Label should be first Label of getLabels()');
        Test.stopTest();
    }
}