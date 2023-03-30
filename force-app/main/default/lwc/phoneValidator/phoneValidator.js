import { LightningElement, api, wire } from 'lwc';
import validatePhone from '@salesforce/apex/LwcUtility.validatePhone';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';


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

    handleValidate(){
        validatePhone({ phone:this.template.querySelector('[data-id="phoneField"]').value})
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
        validatePhone({ phone:this.template.querySelector('[data-id="phoneField"]').value})
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