
import { LightningElement, wire} from 'lwc';
import getPeople from '@salesforce/apex/PersonController.getPersonList';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    {
        label: 'Name',
            fieldName: 'NameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: NAME_FIELD.fieldApiName }, 
            target: '_blank'}
    },
    {
        label: 'Email',
        fieldName: EMAIL_FIELD.fieldApiName,
        type: 'email',
    },
    {
        label: 'Phone',
        fieldName: PHONE_FIELD.fieldApiName,
        type: 'phone',
    },
    {
        label: 'Record Type',
        fieldName: 'RecordType',
        type: 'Text',
    },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

export default class PersonDatatable extends LightningElement {
    columns = columns;
    selectedRecordType;
    people;
    wiredPeopleParams;
    error;
    row={};

    @wire(getPeople)
    wiredPeople(value) {
        this.wiredPeopleParams=value;
        const { data, error } = value;
        if (data) {
            this.people = data.map(x=>{
                let y={};
                for(const field in x){
                    y[field]=x[field];
                }
                y.NameUrl=`/`+x.Id;
                y.RecordType=x.RecordType.Name;
                return y;
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    }
    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        this.row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.template.querySelector('.DeletePersonModal').showModalBox();
                break;
            case 'edit':
                this.template.querySelector('.EditPersonModal').showModalBox();
                break;
            default:
        }
    }

    openRecordTypeModal(event){
        this.template.querySelector('.RecordTypeModal').showModalBox();
    }

    handleRecordTypeSelection(event){
        this.template.querySelector('.RecordTypeModal').hideModalBox();
        this.template.querySelector('.CreatePersonModal').showModalBox();
    }

    handleSelectChange(event){
        this.selectedRecordType=event.detail
    }
    refreshData(){
        return refreshApex(this.wiredPeopleParams);
    }

    deleteRow() {
        this.template.querySelector('.DeletePersonModal').hideModalBox();
        const id = this.row.Id;
        deleteRecord(id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })

                );
                this.refreshData();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

}