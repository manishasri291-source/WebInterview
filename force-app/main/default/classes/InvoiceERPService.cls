public  class InvoiceERPService {
    private static final String ERP_ENDPOINT = 'https://erp.example.com/api/invoices';

    @future(callout=true)
    public static void sendInvoiceToERP(Id invoiceId) {
        Invoice__c inv = [
            SELECT Id, Name, Amount__c, Due_Date__c, Paid__c, Project__r.Name
            FROM Invoice__c WHERE Id = :invoiceId
        ];

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ERP_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        // Build JSON payload
        Map<String, Object> payload = new Map<String, Object>{
            'InvoiceId' => inv.Id,
            'InvoiceName' => inv.Name,
            'Project' => inv.Project__r.Name,
            'Amount' => inv.Amount__c,
            'DueDate' => inv.Due_Date__c,
            'Paid' => inv.Paid__c
        };
        req.setBody(JSON.serialize(payload));

        HttpResponse res = http.send(req);
        System.debug('ERP Response: ' + res.getBody());
    }
}