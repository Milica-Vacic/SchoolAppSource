
import { LightningElement, wire } from 'lwc';
import getPeople from '@salesforce/apex/PersonController.getPersonList';
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
    record = {};
    isVisibleTypeModal=false;
    isVisibleCreateModal=false;
    selectedRecordType;
    people;
    error;

    @wire(getPeople)
    wiredPeople({ error, data }) {
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
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'edit':
                this.editRow(row);
                break;
            default:
        }
    }

    handleCreatePerson(event){
        this.isVisibleTypeModal=true;
    }

    handleRecordTypeSelection(event){
        this.isVisibleTypeModal=false;
        this.isVisibleCreateModal=true;
    }

    handleSelectChange(event){
        this.selectedRecordType=event.detail
    }

    deleteRow(row) {
        //TO BE ADDED
    }


    editRow(row) {
        //TO BE ADDED
    }



}