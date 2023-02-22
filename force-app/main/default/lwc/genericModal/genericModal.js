import { LightningElement, api, track } from 'lwc';

export default class GenericModal extends LightningElement {
    @track isShowModal=false;
    @api title;

    @api hideModalBox(){
        this.isShowModal=false;
    }
    @api showModalBox(){
        this.isShowModal=true;
    }
    

}