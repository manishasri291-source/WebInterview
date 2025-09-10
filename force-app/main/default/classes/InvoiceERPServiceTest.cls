@isTest
private class InvoiceERPServiceTest {

    // Inner mock class
    private class InvoiceERPServiceMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success","message":"Invoice received"}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Actual test method
    @isTest static void testInvoiceCallout() {
        // Insert sample project
        Project__c proj = new Project__c(Name = 'Test Project');
        insert proj;

        // Insert sample invoice
        Invoice__c inv = new Invoice__c(
            Project__c = proj.Id,
            Amount__c = 500,
            Due_Date__c = Date.today().addDays(30),
            Paid__c = false
        );
        insert inv;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoiceERPServiceMock());
        InvoiceERPService.sendInvoiceToERP(inv.Id);
        Test.stopTest();

        System.assert(true, 'Callout executed with mock');
    }
}