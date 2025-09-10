public class InvoiceTriggerHandler {
    public void handleAfterUpdate(List<Invoice__c> newList, Map<Id, Invoice__c> oldMap) {
        Set<Id> projectIdsToUpdate = new Set<Id>();
        
        for (Invoice__c inv : newList) {
            Invoice__c oldInv = oldMap.get(inv.Id);
            
            if (inv.Paid__c == true && (oldInv.Paid__c == false || oldInv.Paid__c == null)) {
                if (inv.Project__c != null) {
                    projectIdsToUpdate.add(inv.Project__c);
                }
            }
        }
        
        if (!projectIdsToUpdate.isEmpty()) {
            List<Project__c> projectsToUpdate = [
                SELECT Id, Status__c
                FROM Project__c
                WHERE Id IN :projectIdsToUpdate
            ];
            
            for (Project__c proj : projectsToUpdate) {
                proj.Status__c = 'Completed';
            }
            
            update projectsToUpdate;
        }
    }
}