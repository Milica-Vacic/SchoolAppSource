@isTest
public class TestDataFactory {
    public static List<Person__C> createPeople(String name, Integer n) {
        List<Person__C> people = new List<Person__C>();
        for (Integer i=0;i<n;i++){
            Person__c p=new Person__c();
            p.First_Name__c=name+i;
            p.Last_Name__c=name+i;
            p.Email__c=name+i+'@gmail.com';
            people.add(p);
        }
        return people;
    }

    public static List<Person__C> createPeople(String name, Integer n, String recordType) {
        Schema.DescribeSObjectResult objType = Schema.SObjectType.Person__C;
        if ( !objType.getRecordTypeInfosByName().containsKey(recordType)) return null;
        List<Person__C> people = new List<Person__C>();
        for (Integer i=0;i<n;i++){
            Person__c p=new Person__c();
            p.First_Name__c=name+i;
            p.Last_Name__c=name+i;
            p.Email__c=name+i+'@gmail.com';
            p.RecordTypeId=objType.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
            people.add(p);
        }
        return people;
    }

    public static List<Course__c> createCourses(String name, Integer n, Id tutor, Integer duration) {
        List<Course__c> courses = new List<Course__c>();
        for (Integer i=0;i<n;i++){
            Course__c c=new Course__c();
            c.Name=name+i;
            c.Tutor__c=tutor;
            c.Start_Date__c=Date.today();
            c.End_Date__c=Date.today()+duration;
            courses.add(c);
        }
        return courses;
    }

    public static List<Participation__c> createParticipations(List<Course__c> Courses, List<Person__c> Students) {
        List<Participation__c> participations = new List<Participation__c>();
        for (Integer i=0;i<Courses.size();i++){
            for (Integer j=0;j<Students.size();j++){
                Participation__c p=new Participation__c();
                p.Course__c=Courses[i].Id;
                p.Student__c=Students[j].Id;
                participations.add(p);
            }
        }
        return participations;
    }
}