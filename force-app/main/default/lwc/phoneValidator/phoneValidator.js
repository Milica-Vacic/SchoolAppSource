import { LightningElement, api, wire } from 'lwc';
import getFieldAccessability from '@salesforce/apex/LwcUtility.getFieldAccessability';
import validatePhone from '@salesforce/apex/LwcUtility.validatePhone';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import COUNTRY_FIELD from '@salesforce/schema/Person__c.Country__c';

const fields = [COUNTRY_FIELD];

export default class PhoneValidator extends LightningElement {
    @api objectApiName;
    @api recordId;
    @api fieldName;
    hasAccess;
    readOnly;
    validationResult;
    phone;

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

    @wire(getRecord, { recordId: '$recordId', fields })
    person;

    get country() {
        return getFieldValue(this.person.data, COUNTRY_FIELD);
    }


    get FieldName(){
        return this.fieldName.charAt(0).toUpperCase() + this.fieldName.slice(1);
    }

    get title(){
        return `Validate ${this.FieldName}`
    }

    handleValidate(event){
        validatePhone({ phone:this.template.querySelector('[data-id="phoneField"]').value, country:this.country})
            .then((result)=>{
                let res=JSON.parse(result);
                res.Items[0].Error ? this.validationResult =`Error! ${res.Items[0].Description}: ${res.Items[0].Cause}` : 
                    `Phone valid? ${res.Items[0].IsValid}`;
            })
            .catch((error)=>{
                this.validationResult=`Error: ${error.body.message}`;
            })
            .then(()=>{this.template.querySelector('[data-id="validationResultModal"]').showModalBox();
            });
    }

    handleViewDetails(){
        //TO BE ADDED
    }
}