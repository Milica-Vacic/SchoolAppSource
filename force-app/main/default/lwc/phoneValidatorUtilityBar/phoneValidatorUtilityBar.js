import { LightningElement, api, wire } from 'lwc';
import validatePhone from '@salesforce/apex/LwcUtility.validatePhone';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord} from 'lightning/uiRecordApi';
import hasPermission from '@salesforce/customPermission/AccessPhoneValidator';

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

    handleValidate(){
        let phoneParam=(this.sObjectId) ? this.template.querySelector('[data-id="phoneField"]').value : 
            this.template.querySelector('[data-id="phoneFieldRecordless"]').value;

        validatePhone({ phone:phoneParam})
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
    let phoneParam=(this.sObjectId) ? this.template.querySelector('[data-id="phoneField"]').value : 
                this.template.querySelector('[data-id="phoneFieldRecordless"]').value;

        validatePhone({ phone:phoneParam})
            .then((result)=>{
                let res=JSON.parse(result);
                this.validationDetails=res.Items;
                this.columns=[];
                for(let fname in res.Items[0]){
                    this.columns.push({label:fname, fieldName:fname, type:'text', wrapText:true})
                }
                this.template.querySelector('[data-id="validationDetailsModal"]').showModalBox();
            })
            .catch((error)=>{
                this.validationResult=`Error: ${error.body.message}`;
                this.template.querySelector('[data-id="validationResultModal"]').showModalBox();
            })
    }
}