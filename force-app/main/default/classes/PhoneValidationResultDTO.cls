public with sharing class PhoneValidationResultDTO {
    public List<Items> Items;

    public class Items {

        public Object get(String param_name){
            Map<String, Object> untyped_instance;
            String json_instance = Json.serialize(this);
            untyped_instance=(Map<String, Object>)JSON.deserializeUntyped(json_instance);
            return untyped_instance.get(param_name);
        }

        public String PhoneNumber;
        public Boolean RequestProcessed;
        public String IsValid;
        public String NetworkCode;
        public String NetworkName;
        public String NetworkCountry;
        public String NationalFormat;
        public Integer CountryPrefix;
        public String NumberType;
        public Integer Id;
        public String Error;
        public String Cause;
        public String Resolution;
    }
    
    public static PhoneValidationResultDTO parse(String json) {
        return (PhoneValidationResultDTO) System.JSON.deserialize(json, PhoneValidationResultDTO.class);
    }
}