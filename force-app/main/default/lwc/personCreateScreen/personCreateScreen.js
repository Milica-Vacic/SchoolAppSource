import { LightningElement, api } from 'lwc';
import OBJECT_NAME from '@salesforce/schema/Person__c';

export default class PersonCreateScreen extends LightningElement {
    objectName=OBJECT_NAME;
    @api recordTypeId;

    handleSuccess(){
        //go to rec page
    }
    handleError(){
        //toast an error message
    }
}