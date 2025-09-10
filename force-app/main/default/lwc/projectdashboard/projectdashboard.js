import { LightningElement, track, wire } from 'lwc';
import getProjectsWithInvoices from '@salesforce/apex/ProjectDashboardController.getProjectsWithInvoices';
import updateInvoices from '@salesforce/apex/ProjectDashboardController.updateInvoices';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ProjectDashboard extends LightningElement {
    @track projects = [];
    @track draftValues = [];

    columns = [
        { label: 'Invoice Name', fieldName: 'Name', type: 'text' },
        { label: 'Amount', fieldName: 'Amount__c', type: 'currency', editable: true },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        { label: 'Paid', fieldName: 'Paid__c', type: 'boolean', editable: true }
    ];

    @wire(getProjectsWithInvoices)
    wiredProjects({ error, data }) {
        if (data) {
            this.projects = JSON.parse(JSON.stringify(data));
        } else if (error) {
            this.showToast('Error', 'Failed to load Projects: ' + error.body.message, 'error');
        }
    }

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        try {
            await updateInvoices({ invoicesToUpdate: updatedFields });

            // Apply changes locally so UI updates instantly
            updatedFields.forEach(draft => {
                this.projects.forEach(proj => {
                    if (proj.Invoices__r) {
                        proj.Invoices__r.forEach(inv => {
                            if (inv.Id === draft.Id) {
                                Object.assign(inv, draft);
                            }
                        });
                    }
                });
            });

            this.showToast('Success', 'Invoices updated successfully!', 'success');
            this.draftValues = [];
        } catch (error) {
            this.showToast('Error', 'Error updating invoices: ' + error.body.message, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}