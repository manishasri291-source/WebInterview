@isTest
private class InvoiceTriggerHandlerTest {

    @testSetup
    static void setupData() {
        List<Project__c> projects = new List<Project__c>();
        for (Integer i = 0; i < 5; i++) {
            projects.add(new Project__c(Name = 'Test Project ' + i, Status__c = 'In Progress'));
        }
        insert projects;

        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i = 0; i < projects.size(); i++) {
            invoices.add(new Invoice__c(Name = 'Invoice ' + i, Paid__c = false, Project__c = projects[i].Id));
        }
        insert invoices;
    }

    @isTest
    static void testInvoicePaidTrue_UpdatesProjectStatus() {
        List<Invoice__c> invoicesToUpdate = [SELECT Id, Paid__c FROM Invoice__c];

        for (Invoice__c inv : invoicesToUpdate) {
            inv.Paid__c = true;
        }

        Test.startTest();
        update invoicesToUpdate;
        Test.stopTest();

        List<Project__c> updatedProjects = [SELECT Id, Status__c FROM Project__c];
        for (Project__c proj : updatedProjects) {
            System.assertEquals('Completed', proj.Status__c, 'Project status should be updated to Completed');
        }
    }

    @isTest
    static void testNoChangeWhenAlreadyPaid() {
         Invoice__c inv = [SELECT Id FROM Invoice__c LIMIT 1];
        inv.Paid__c = true;
        update inv;

         inv = [SELECT Id, Paid__c FROM Invoice__c WHERE Id = :inv.Id];
        inv.Name = 'Updated Name';  
        Test.startTest();
        update inv;
        Test.stopTest();

         Project__c proj = [SELECT Id, Status__c FROM Project__c WHERE Id = :inv.Project__c];
        System.assertEquals('Completed', proj.Status__c);
    }
}