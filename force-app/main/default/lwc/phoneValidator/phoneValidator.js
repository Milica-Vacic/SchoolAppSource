import { LightningElement, api, wire } from 'lwc';
import getFieldAccessability from '@salesforce/apex/LwcUtility.getFieldAccessability';

export default class PhoneValidator extends LightningElement {
    @api objectApiName;
    @api recordId;
    @api fieldName;

    @wire(getFieldAccessability,{objectApiName:'$objectApiName', fieldName:'$fieldName'})
    __access;

    get hasAccess(){
        if (this.__access=='unreadable') return false;
        else return true;
    }

    get readOnly(){
        if (this.__access=='readable') return true;
        else return false;
    }

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