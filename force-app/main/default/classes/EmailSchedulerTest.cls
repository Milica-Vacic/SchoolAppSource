@isTest
public class EmailSchedulerTest {

    @isTest public static void execute_NoEmptyCourses_NoEmailSent(){
        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 1, 'Tutor');
        List<Person__c> students= TestDataFactory.createPeople('Student', 1, 'Student');
        List<Person__c> people= new  List<Person__c>(tutor);
        people.addAll(students);
        insert people;
        List<Course__c> courses=TestDataFactory.createCourses('Course', 1, tutor[0].Id, 5);
        insert courses;
        List<Participation__c> partics = TestDataFactory.createParticipations(courses, students);
        insert partics;
        Test.startTest();
        String jobId = System.schedule('execute_NoEmptyCourses_NoEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
           FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(EmailScheduler.CRON_EXP, ct.CronExpression, 'Schedule time not set properly');
        System.assertEquals(0, ct.TimesTriggered, 'execute_NoEmptyCourses_NoEmailSent should not have been triggered yet');
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();
  
        System.assertEquals(null, EmailScheduler.sendMailResults, 'No emails should have been sent');
    }
    @isTest public static void execute_SingleEmptyCourse_OneEmailSent(){

        List<Person__c> tutor= TestDataFactory.createPeople('Tutor', 2, 'Tutor');
        insert tutor;
        List<Course__c> courses=TestDataFactory.createCourses('FirstCourse', 1, tutor[0].Id, 5);
        courses.addAll(TestDataFactory.createCourses('SecondCourse', 1, tutor[1].Id, 5));
        insert courses;
        Test.startTest();
        String jobId = System.schedule('execute_SingleEmptyCourse_OneEmailSent', EmailScheduler.CRON_EXP, new EmailScheduler());
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should have been sent');
        Test.stopTest();
  
        System.assertEquals(2, EmailScheduler.sendMailResults.size(), 'Number of sent emails is incorrect');
        for(Messaging.SendEmailResult res:EmailScheduler.sendMailResults){
            System.assert(res.isSuccess(), 'Email was not succesfully sent');
            if (!res.isSuccess()){
                for (Messaging.SendEmailError er:res.getErrors()){
                    System.debug(er.getMessage());
                }
            }
        }

    }
    @isTest public static void execute_MultipleEmptyCourses_MultipleEmailsSent(){
        //make sure some profesors have a cingle course and others have multiple
        
    }
}