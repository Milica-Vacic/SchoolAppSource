public with sharing class EmailScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        EmailSender es = new EmailSender();
        es.sendEmptyCourseAlert();
     }
}