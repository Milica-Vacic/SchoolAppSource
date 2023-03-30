public with sharing class LwcUtility {
    @AuraEnabled
    public static String validatePhone(String phone, String country) {
        HttpResponse res = PhoneValidationAPI.validate(phone, country);
        return res.getBody();
    }
}