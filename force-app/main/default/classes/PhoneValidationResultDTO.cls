public with sharing class PhoneValidationResultDTO {
    public List<Items> Items;

    public class Items {
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
    
    public PhoneValidationResultDTO parse(String json) {
        return (PhoneValidationResultDTO) System.JSON.deserialize(json, PhoneValidationResultDTO.class);
    }
}