import { LightningElement, wire } from 'lwc';
//import getRecordTypes from '@salesforce/apex/PersonController.getPersonRecordTypeList';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PERSON_OBJECT from '@salesforce/schema/Person__c';

export default class SelectPersonRecordType extends LightningElement {
    value;
    options;
    error;

    @wire(getObjectInfo, { objectApiName: PERSON_OBJECT })
    objectInfo({error,data}){
        if (data) {
            this.options={}
            for (let rtId of data.recordTypeInfos){
                this.options.push({label:data.recordTypeInfos[rtId].Name, value:rtId});
            }
            this.error = undefined;
            this.value=this.options[0];
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    }


    //TODO get Record Types from https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.data_considerations instead of APEX
/*     @wire(getRecordTypes)
    wiredRecordTypes({ error, data }) {
        if (data) {
            this.options = data.map(x=>{
                return {label:x.Name, value:x.Id};
            });
            this.error = undefined;
            this.value=this.options[0];
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    } */

    handleChange(event) {
        this.value = event.detail.value;
        this.dispatchEvent(new CustomEvent('selectchange', {
            detail: this.value
          }));
    }

}