public with sharing class ProjectDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsWithInvoices() {
        return [
            SELECT Id, Name, Status__c, Budget__c, Start_Date__c, End_Date__c,
                   (SELECT Id, Name, Amount__c, Due_Date__c, Paid__c 
                    FROM Invoices__r 
                    ORDER BY Due_Date__c ASC)
            FROM Project__c
            ORDER BY Start_Date__c DESC
            LIMIT 50
        ];
    }

    @AuraEnabled
    public static void updateInvoices(List<Invoice__c> invoicesToUpdate) {
        try {
            update invoicesToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating Invoices: ' + e.getMessage());
        }
    }
}