import { LightningElement, api } from 'lwc';
import OBJECT_NAME from '@salesforce/schema/Person__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';


export default class PersonCreateScreen extends NavigationMixin(LightningElement) {
    objectName=OBJECT_NAME;
    @api recordTypeId;
    name;

    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        if (fields.Phone__c) fields.Phone__c = '+381'+fields.Phone__c;
        if (fields.Work_Phone__c) fields.Work_Phone__c = '+381'+fields.Work_Phone__c;
        this.name=` ${fields.First_Name__c} ${fields.Last_Name__c}`;
        this.template.querySelector('lightning-record-form').submit(fields);
    }
    handleSuccess(event){
        const fields = event.detail.fields;
        const evt = new ShowToastEvent({
            title: 'Success!',
            message: `Person ${this.name} successfully created`,
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

    handleError(event){
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: `Encountered error while creating persson ${this.name}.
            Error: ${event.detail.message}`,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }
}