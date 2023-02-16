
import { LightningElement, wire } from 'lwc';
import getPeople from '@salesforce/apex/PersonController.getPersonList';

import NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';
import TYPE_FIELD from '@salesforce/schema/Person__c.RecordTypeId';


const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    {
        label: 'Name',
        fieldName: NAME_FIELD.fieldApiName,
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
        fieldName: TYPE_FIELD.fieldApiName,
        type: 'RecordType',
    },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

export default class PersonDatatable extends LightningElement {
    columns = columns;
    record = {};

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

    deleteRow(row) {
        //TO BE ADDED
    }


    editRow(row) {
        //TO BE ADDED
    }

}