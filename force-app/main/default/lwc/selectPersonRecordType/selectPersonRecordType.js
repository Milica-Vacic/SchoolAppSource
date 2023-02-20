import { LightningElement, wire } from 'lwc';
import getRecordTypes from '@salesforce/apex/PersonController.getPersonRecordTypeList';

export default class SelectPersonRecordType extends LightningElement {
    value;
    options;
    error;

    @wire(getRecordTypes)
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
    }

    handleChange(event) {
        this.value = event.detail.value;
        this.dispatchEvent(new CustomEvent('selectchange', {
            detail: this.value
          }));
    }

}