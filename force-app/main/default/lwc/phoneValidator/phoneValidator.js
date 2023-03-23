import { LightningElement, api } from 'lwc';

export default class PhoneValidator extends LightningElement {
    @api objectApiName;
    @api recordId;
    @api fieldName;

    get FieldName(){
        return this.fieldName.charAt(0).toUpperCase() + this.fieldName.slice(1);
    }

    get title(){
        return `Validate ${this.FieldName}`
    }

    handleValidate(){
        //TO BE ADDED
    }

    handleViewDetails(){
        //TO BE ADDED
    }
}