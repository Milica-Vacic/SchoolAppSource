public with sharing class LwcUtility {
    @AuraEnabled(cacheable=true)
    public static String getFieldAccessability(String objectApiName, String fieldName) {
        String access='unreadable';
        DescribeFieldResult field=Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        if (field.isUpdateable()) {
            access='updatable';
        }
        else if (field.isAccessible()){
            access='readable';
        }
        return access;                 
    }

    @AuraEnabled
    public static String validatePhone(String phone, String country) {
        HttpResponse res = PhoneValidationAPI.validate(phone, country);
        return res.getBody();
    }
}