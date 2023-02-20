
import { LightningElement, wire} from 'lwc';
import getPeople from '@salesforce/apex/PersonController.getPersonWithRecordTypeList';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    {
        label: 'Name',
            fieldName: 'NameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, 
            target: '_blank'}
    },
    {
        label: 'Email',
        fieldName: 'Email',
        type: 'email',
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
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

    @wire(getPeople)
    people;

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