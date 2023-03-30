import { LightningElement, api, wire } from 'lwc';
import { getDetailData, getDetailColumns, getResponse } from 'c/phoneValidationUtility';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord} from 'lightning/uiRecordApi';
import hasPermission from '@salesforce/customPermission/AccessPhoneValidator';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PhoneValidatorUtilityBar extends LightningElement {
    @api sObjectId;
    sObjectName;
    selectedField;
    hasAccess;
    readOnly;
    validationResult;
    validationDetails;
    columns;
    phoneFields=[];

    @wire(getRecord, { recordId: '$sObjectId', fields:['Name'] })
    record({error, data}) {
            if (error) {
                this.hasAccess=false;
                this.readOnly=false;
                this.phoneFields=undefined;
            } 
            else if (data) {
                this.sObjectName=data.apiName;
            }
        }

    @wire(getObjectInfo, { objectApiName: '$sObjectName'})
        objectInfo({error, data}) {
            if (error) {
                this.hasAccess=false;
                this.readOnly=false;
                this.phoneFields=undefined;
            } 
            else if (data) {
                this.phoneFields=[];
                for(let fname of Object.keys(data.fields)){
                    if (data.fields[fname].dataType=='Phone'){
                        this.phoneFields.push({label:data.fields[fname].label, value:fname});
                    }
                }
                this.selectedField=this.phoneFields[0].value;
                this.hasAccess=data.fields[this.selectedField] ? true : false;
                this.readOnly=!data.fields[this.selectedField].updateable;

            }
        }


    handleFieldChange(event){
        this.selectedField = event.detail.value;
    }

    get componentAccess(){
        return hasPermission;
    }

    get title(){
        return `Validate ${this.selectedField}`
    }

    async handleValidate(){
        let phoneParam=(this.sObjectId) ? this.template.querySelector('[data-id="phoneField"]').value : 
            this.template.querySelector('[data-id="phoneFieldRecordless"]').value;

        this.validationResult=await getResponse(phoneParam);
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