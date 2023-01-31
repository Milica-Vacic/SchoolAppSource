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
}