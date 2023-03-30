import { LightningElement, api, wire } from 'lwc';
import { getDetailData, getDetailColumns, getResponse } from 'c/phoneValidationUtility';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import hasPermission from '@salesforce/customPermission/AccessPhoneValidator';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class PhoneValidator extends LightningElement {
    @api objectApiName;
    @api recordId;
    @api fieldName;
    hasAccess;
    readOnly;
    validationResult;
    validationDetails;
    columns;



 @wire(getObjectInfo, { objectApiName: '$objectApiName'})
    objectInfo({error, data}) {
        if (error) {
            this.hasAccess=false;
            this.readOnly=false;
        } 
        else if (data) {
            this.hasAccess=(data.fields[this.FieldName]!=undefined);
            this.readOnly=!data.fields[this.FieldName].updateable; 
        }
    }

    get FieldName(){
        return this.fieldName.charAt(0).toUpperCase() + this.fieldName.slice(1);
    }

    get title(){
        return `Validate ${this.FieldName}`
    }

    get componentAccess(){
        return hasPermission;
    }

    async handleValidate(){
        this.validationResult=await getResponse(this.template.querySelector('[data-id="phoneField"]').value);
        this.template.querySelector('[data-id="validationResultModal"]').showModalBox();
    }

    handleViewDetails(){
        this.validationDetails=getDetailData();
        this.columns=getDetailColumns();
        if (this.validationDetails && this.columns)
            this.template.querySelector('[data-id="validationDetailsModal"]').showModalBox();
        else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error retrieving details',
                    message: 'Make sure you have succesfully validated a phone number before reqesting validation details',
                    variant: 'error'
                })
            );
        }
    }
}