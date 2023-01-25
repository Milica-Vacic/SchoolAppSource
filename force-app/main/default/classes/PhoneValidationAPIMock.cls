@isTest
public with sharing class PhoneValidationAPIMock implements HttpCalloutMock{

    //make a variable for the succes body and fail body here, teest vissible, use it to validate stuff

    public HTTPResponse respond(HTTPRequest req){
        System.assertEquals('https://api.addressy.com/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws', req.getEndpoint(), 'Incorrect request endpoint');
        System.assertEquals('GET', req.getMethod(), 'Incorrect request method, should be GET');
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        PageReference ref = new PageReference(req.getEndpoint());

        if (!((String)ref.getParameters().get('Phone')).isNumeric()){
            res.setBody('{"Items":[{"Id":1002,"Error":"Invalid phone number format","Cause":"The phone number provided is not in a valid international format.","Resolution":"Please ensure that you supply a phone number and try again."}]}');
        }
        else{
            String body='{"Items":[{"PhoneNumber":"{0}}","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"+381","NetworkName":"A1",'
                +'"NetworkCountry":"SRB","NationalFormat":"0604009911","CountryPrefix":381,"NumberType":"MOBILE"}] }';
            body=String.format(body, new List<String>{ref.getParameters().get('Phone')});
            res.setBody(body);
        }
        return res;
    }
}