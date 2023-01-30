public with sharing class EmailScheduler implements Schedulable {
    public static String CRON_EXP = '0 0 8 * * ?';
    @TestVisible public static List<Messaging.SendEmailResult> sendMailResults;

    public void execute(SchedulableContext SC) {
        EmailSender.sendEmptyCourseAlert();   
     }
}