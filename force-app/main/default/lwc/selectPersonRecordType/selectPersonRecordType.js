import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PERSON_OBJECT from '@salesforce/schema/Person__c';

export default class SelectPersonRecordType extends LightningElement {
    value;
    options;
    error;

    @wire(getObjectInfo, { objectApiName: PERSON_OBJECT })
    objectInfo({error,data}){
        if (data) {
            this.options=[];
            for (let rtId of Object.keys(data.recordTypeInfos)){
                if(data.recordTypeInfos[rtId].name!='Master')
                    this.options.push({label:data.recordTypeInfos[rtId].name, value:rtId});
            }
            this.error = undefined;
            this.value=this.options[0];
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    }

    handleChange(event) {
        this.value = event.detail.value;
        this.dispatchEvent(new CustomEvent('selectchange', {
            detail: this.value
          }));
    }

}