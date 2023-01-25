public with sharing class PhoneValidationResultDTO {
    public List<Items> Items;

    public class Items {
        private Map<String, Object> untyped_instance;

        public Object get(String param_name){
            if (untyped_instance==null){
                String json_instance = Json.serialize(this);
                untyped_instance=(Map<String, Object>)JSON.deserializeUntyped(json_instance);
            }
            return untyped_instance.get(param_name);
        }

        private String PhoneNumber;
        private Boolean RequestProcessed;
        private String IsValid;
        private String NetworkCode;
        private String NetworkName;
        private String NetworkCountry;
        private String NationalFormat;
        private Integer CountryPrefix;
        private String NumberType;
        private Integer Id;
        private String Error;
        private String Cause;
        private String Resolution;
    }
    
    public static PhoneValidationResultDTO parse(String json) {
        return (PhoneValidationResultDTO) System.JSON.deserialize(json, PhoneValidationResultDTO.class);
    }
}