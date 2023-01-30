public with sharing class EmailSender {
    public EmailSender() {
    }
  
    public void sendEmptyCourseAlert(){
            List<Course__c> emptyCourses=[SELECT Name, Id, Tutor__r.Id, Tutor__r.Name, Tutor__r.Email__c
                from Course__c WHERE Attendees_Count__c=0 AND Completed__c=false];
            if (emptyCourses.size()==0) return;
            Messaging.reserveSingleEmailCapacity(emptyCourses.size());
            Map<Id, Messaging.SingleEmailMessage> msgMap = new Map<Id, Messaging.SingleEmailMessage>();
            for (Course__c c:emptyCourses){
                if(!msgMap.containsKey(c.Tutor__r.Id)) {
                    Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
                    mail.setCcAddresses(new List<String>{c.Tutor__r.Email__c});
                    mail.setSenderDisplayName('Salesforce Support');
                    mail.setSubject('Alert about courses with no attendees');
                    mail.setReplyTo('no-reply@company.com');
                    String body = 'Dear {0},<br><br> some of the courses you teach have no attendees at present:<br><a href={1}/{2}>{3}</a>';
                    body=String.format(body, new List<String>{c.Tutor__r.Name, URL.getSalesforceBaseUrl().toExternalForm(), c.Id, c.Name});
                    mail.setHtmlBody(body);
                    msgMap.put(c.Tutor__r.Id, mail);
                }
                else{
                    String addBody = '<br><a href={0}/{1}>{2}</a>';
                    addBody=String.format(addBody, new List<String>{URL.getSalesforceBaseUrl().toExternalForm(), c.Id, c.Name});
                    msgMap.get(c.Tutor__r.Id).setHtmlBody(msgMap.get(c.Tutor__r.Id).getHtmlBody()+addBody);
                }
            }
            Messaging.sendEmail(msgMap.values());
            
            
    }
}