import { LightningElement, api } from 'lwc';
import OBJECT_NAME from '@salesforce/schema/Person__c';

export default class PersonDetails extends LightningElement {
    @api recordId;
    objectName=OBJECT_NAME;
}