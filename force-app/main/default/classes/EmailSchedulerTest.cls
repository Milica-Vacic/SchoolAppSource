@isTest
public class EmailSchedulerTest {

    @isTest public static void execute_NoEmptyCourses_NoEmailSent(){
        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 1, 'Tutor');
        List<Person__c> students= TestDataFactory.createPeople('Student', 1, 'Student');
        List<Person__c> people= new  List<Person__c>(tutor);
        people.addAll(students);
        insert people;
        List<Course__c> courses=TestDataFactory.createCourses('Course', 1, tutor[0].Id, 5);
        Test.startTest();
        insert courses;
        List<Participation__c> partics = TestDataFactory.createParticipations(courses, students);
        insert partics;
        String jobId = System.schedule('execute_NoEmptyCourses_NoEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
           FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(EmailScheduler.CRON_EXP, ct.CronExpression, 'Schedule time not set properly');
        System.assertEquals(0, ct.TimesTriggered, 'execute_NoEmptyCourses_NoEmailSent should not have been triggered yet');
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();
  
        System.assertEquals(null, EmailScheduler.sendMailResults, 'No emails should have been sent');
    }
    
    @isTest public static void execute_SingleEmptyCourse_OneEmailPerTutor(){

        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 2, 'Tutor');
        insert tutor;
        List<Course__c> courses=TestDataFactory.createCourses('FirstCourse', 1, tutor[0].Id, 5);
        courses.addAll(TestDataFactory.createCourses('SecondCourse', 1, tutor[1].Id, 5));
        Test.startTest();
        insert courses;
        String jobId = System.schedule('execute_SingleEmptyCourse_OneEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();
  
        System.assertEquals(2, EmailScheduler.sendMailResults.size(), 'Number of sent emails is incorrect');
        for(Messaging.SendEmailResult res:EmailScheduler.sendMailResults){
            System.assert(res.isSuccess(), 'Email was not succesfully sent');
        }
        Messaging.SingleEmailMessage testMsg=EmailSender.tutor_email.get(tutor[0].Id);
        String expected='Dear Tutor0 Tutor0,<br><br> some of the courses you teach have no attendees at present:<br><a href={0}/{1}>FirstCourse0</a>';
        expected=String.format(expected,new List<String>{URL.getSalesforceBaseUrl().toExternalForm(), courses[0].Id});
        System.assertEquals(expected,testMsg.getHtmlBody(),'Invalid email body');

    }
    @isTest public static void execute_MultipleEmptyCourses_OneEmailPerTutor(){
        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 2, 'Tutor');
        insert tutor;
        List<Course__c> courses=TestDataFactory.createCourses('FirstCourse', 1, tutor[0].Id, 5);
        courses.addAll(TestDataFactory.createCourses('SecondCourse', 2, tutor[1].Id, 5));
        Test.startTest();
        insert courses;
        String jobId = System.schedule('execute_SingleEmptyCourse_OneEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();

        Messaging.SingleEmailMessage testMsg=EmailSender.tutor_email.get(tutor[1].Id);
        String expected='Dear Tutor1 Tutor1,<br><br> some of the courses you teach have no attendees at present:<br><a href={0}/{1}>SecondCourse0</a><br><a href={2}/{3}>SecondCourse1</a>';
        expected=String.format(expected,new List<String>{URL.getSalesforceBaseUrl().toExternalForm(), courses[1].Id,URL.getSalesforceBaseUrl().toExternalForm(),courses[2].Id});
        System.assertEquals(expected,testMsg.getHtmlBody(),'Invalid email body');
        System.assertEquals(2, EmailScheduler.sendMailResults.size(), 'Number of sent emails is incorrect');
        for(Messaging.SendEmailResult res:EmailScheduler.sendMailResults){
            System.assert(res.isSuccess(), 'Email was not succesfully sent');
        }
        
    }

    @isTest public static void execute_7Emails(){
        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 7, 'Tutor');
        insert tutor;
        List<Course__c> courses=new List<Course__c>();
        for(Person__c t:tutor){
            courses.addAll(TestDataFactory.createCourses('Course'+t.Id, 1, t.Id, 5));
        }
        Test.startTest();
        insert courses;
        String jobId = System.schedule('execute_SingleEmptyCourse_OneEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();
        System.assertEquals(7, EmailScheduler.sendMailResults.size(), 'Number of sent emails is incorrect');
        for(Messaging.SendEmailResult res:EmailScheduler.sendMailResults){
            System.assert(res.isSuccess(), 'Email was not succesfully sent');
        }
    }


}