@isTest
public with sharing class APIMock implements HttpCalloutMock{
    Integer statusCode;
    Map<String,String> header;
    String body;

    public APIMock(Integer statusCode, Map<String,String> header, String body){
        this.statusCode=statusCode;
        this.header=header;
        this.body=body;
    }

    public HTTPResponse respond(HTTPRequest req){
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(statusCode);
        for(String key:header.keySet()){
            res.setHeader(key, header.get(key));
        }
        res.setBody(body);
        return res;
    }
}