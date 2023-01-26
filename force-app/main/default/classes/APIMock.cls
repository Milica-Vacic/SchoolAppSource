@isTest
public with sharing class APIMock implements HttpCalloutMock{

    public HTTPResponse respond(HTTPRequest req){
        HTTPResponse res = new HTTPResponse();
        String strippedURL= req.getEndpoint().substring(0, req.getEndpoint().indexOf('?'));
        ValidationAPISettings__mdt mdt= (ValidationAPISettings__mdt)ValidationAPISettings__mdt.getInstance('Default');

        //Attempted switch case first, but since I needed literal values for that and the url contained '//'
        //I couldn't find a way to make it work and not comment out the rest of the line after https://....

        if (strippedURL.equals(mdt?.URL__c)){
            System.assertEquals('GET', req.getMethod(), 'Incorrect request method, should be GET');
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            PageReference ref = new PageReference(req.getEndpoint());
            Pattern digitPlus = Pattern.compile('^[0-9+]+$');
            Matcher matcher = digitPlus.matcher((String)ref.getParameters().get('Phone'));

            if (!matcher.matches()){
                res.setBody('{"Items":[{"Id":1002,"Error":"Invalid phone number format","Cause":"The phone number provided is not in a valid international format.","Resolution":"Please ensure that you supply a phone number and try again."}]}');
            }
            else{
                String body='{"Items":[{"PhoneNumber":"{0}","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"+381","NetworkName":"A1",'
                    +'"NetworkCountry":"{1}","NationalFormat":"0604009911","CountryPrefix":381,"NumberType":"MOBILE"}] }';
                body=body.replace('{0}', (String)ref.getParameters().get('Phone'));
                body=body.replace('{1}', (String)ref.getParameters().get('Country'));
                res.setBody(body);
            }	
        }
        else {
            res.setStatusCode(404);
                res.setHeader('Content-Type', 'application/json;charset=UTF-8');
                String body='{"ErrorInfo":"Entered url not found by mock callout class"}';
                res.setBody(body);	  

        }
        return res;
    }
}