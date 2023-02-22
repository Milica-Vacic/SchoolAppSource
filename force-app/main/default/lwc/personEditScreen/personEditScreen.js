import { LightningElement, api } from 'lwc';
import OBJECT_NAME from '@salesforce/schema/Person__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class PersonEditScreen extends LightningElement {
    @api recordId;
    objectName=OBJECT_NAME;
    name;

    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        this.name=` ${fields.First_Name__c} ${fields.Last_Name__c}`;
        this.template.querySelector('lightning-record-form').submit(fields);
    }

    handleSuccess(event){
        this.dispatchEvent(new CustomEvent('dataedit'));

        const evt = new ShowToastEvent({
            title: 'Success!',
            message: `Person ${this.name} successfully edited`,
            variant: 'success',
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: OBJECT_NAME,
                actionName: 'view'
            }
        });
    }
}