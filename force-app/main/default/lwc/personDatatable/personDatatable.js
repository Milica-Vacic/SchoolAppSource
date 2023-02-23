
import { LightningElement, wire, track} from 'lwc';
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
            target: '_blank'},
            sortable: true
    },
    {
        label: 'Email',
        fieldName: EMAIL_FIELD.fieldApiName,
        type: 'email',
        sortable: true
    },
    {
        label: 'Phone',
        fieldName: PHONE_FIELD.fieldApiName,
        type: 'phone',
        sortable: true
    },
    {
        label: 'Record Type',
        fieldName: 'RecordType',
        type: 'Text',
        sortable: true
    },
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

const DELAY = 300;

export default class PersonDatatable extends LightningElement {
    columns = columns;
    selectedRecordType;
    people;
    loadedPeople=[];
    loadedCount;
    tableLoadOffset=10;
    skipOnDataLoad=false;
    @track moreToLoad=true;
    wiredPeopleParams;
    error;
    row={};
    searchKey='';
    @track sortBy;
    @track sortDirection;
    sortFieldName;

    @wire(getPeople, { searchKey: '$searchKey' })
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
            if (this.sortBy) this.sortData(this.sortFieldName, this.sortDirection, this.nullToEmpty);
            this.skipOnDataLoad=true;
            this.loadedPeople = this.people.slice(0, this.tableLoadOffset);
            this.loadedCount=this.tableLoadOffset;
            if (this.loadedCount<this.people.length) this.moreToLoad=true;
            this.template.querySelector('lightning-datatable').scrollTop=0;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.people = undefined;
        }
    }

    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }
    
    handleRowAction(event) {
        this.searchKey='';
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
        this.searchKey='';
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

    nullToEmpty(val){
        return val?val:'';
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortFieldName=this.sortBy=='NameUrl'?NAME_FIELD.fieldApiName:event.detail.fieldName;
        this.sortData(this.sortFieldName, this.sortDirection, this.nullToEmpty);
    }

    sortData(fieldname, direction, valuePrep) {
        const clonePeople = [...this.people];
        let keyValue = (a) => {
            if (valuePrep) return valuePrep(a[fieldname]);
            return a[fieldname]
        };
        let isReverse = direction === 'asc' ? 1: -1;

        clonePeople.sort((x, y) => {
            x = keyValue(x);
            y = keyValue(y);
            return isReverse * ((x > y) - (y > x));
        });
        this.people = clonePeople;
    }
    

    handleLoadMore(event) {
        if(this.skipOnDataLoad){
            this.skipOnDataLoad=false;
            return;
        }
        this.loadedCount = this.loadedPeople.length + this.tableLoadOffset;
        if (this.loadedCount >= this.people.length) this.moreToLoad = false;
        this.loadedCount = (this.loadedCount > this.people.length) ? this.people.length : this.loadedCount; 
        event.target.isLoading = true;
        this.loadedPeople = this.people.slice(0, this.loadedCount);
        event.target.isLoading = false;
        
    }

}