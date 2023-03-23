import { LightningElement, api, wire } from 'lwc';
import getFieldAccessability from '@salesforce/apex/LwcUtility.getFieldAccessability';

export default class PhoneValidator extends LightningElement {
    @api objectApiName;
    @api recordId;
    @api fieldName;
    hasAccess;
    readOnly;

    @wire(getFieldAccessability,{objectApiName:'$objectApiName', fieldName:'$fieldName'})
    access({ error, data }) {
        if (data) {
            this.hasAccess=data=='unreadable'?false:true;
            this.readOnly=data=='readable'?true:false;
          } else if (error) {
            this.hasAccess=false;
            this.readOnly=false;
          }
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