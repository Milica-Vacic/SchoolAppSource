import { LightningElement, api } from 'lwc';

export default class GenericModal extends LightningElement {
    @api isShowModal=false;
    @api title;

    hideModalBox(event){
        this.isShowModal=false;
    }

    bubbleEvent(event){
        this.dispatchEvent(new CustomEvent(event.type, {
            detail: event.detail
          }));
    }
}