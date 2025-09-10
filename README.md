# Project Management & Invoice System

This is a Salesforce solution I built for managing projects and automatically generating invoices. It's designed to streamline the project-to-invoice workflow with some nice automation features.

## What it does

The system handles the complete project lifecycle:
- Track projects with budgets and timelines
- Automatically create invoices when projects are completed
- Send invoice data to external ERP systems
- Provide a dashboard for managing everything
- Update project status when invoices are paid

## Quick Start

If you just want to deploy this to your org, jump to the [Deployment](#deployment) section. Otherwise, read on for the full details.

## How it's built

I structured this using standard Salesforce patterns - nothing fancy, just clean separation of concerns:

- **Lightning Web Components** for the UI (the dashboard)
- **Apex Controllers** to handle the business logic
- **Flows** for the automation (when projects complete)
- **Custom Objects** to store the data
- **Triggers** for the invoice-to-project updates

## What's included

### Custom Objects

**Project__c** - Stores project information
- Name (Text)
- Budget__c (Currency) 
- Start_Date__c (Date)
- End_Date__c (Date)
- Status__c (Picklist: In Progress, Completed, On Hold, Cancelled)

**Invoice__c** - Manages invoices linked to projects
- Name (Text)
- Amount__c (Currency)
- Due_Date__c (Date) 
- Paid__c (Checkbox)
- Project__c (Lookup to Project__c)

### Apex Classes

**ProjectDashboardController** - Handles the dashboard data
- `getProjectsWithInvoices()` - Gets projects with their invoices
- `updateInvoices()` - Updates invoice records

**InvoiceTriggerHandler** - Manages invoice business logic
- `handleAfterUpdate()` - Updates project status when invoices are paid

**InvoiceERPService** - Integrates with external ERP
- `sendInvoiceToERP()` - Sends invoice data to ERP system (async)

### Lightning Web Component

**projectdashboard** - The main dashboard
- Shows projects with related invoices
- Inline editing for invoice amounts and payment status
- Real-time updates

### Flow

**Create_Invoice_on_Project_Completion** - The automation
- Triggers when a project status changes to "Completed"
- Checks if invoice already exists
- Creates new invoice or updates existing one
- Sets due date to 30 days from creation

## Prerequisites

You'll need:
- Salesforce org with API version 64.0+
- Lightning Experience enabled
- Permissions to create custom objects and fields
- Salesforce CLI (for deployment)

## Deployment

### Option 1: Salesforce CLI (Recommended)

First, clone the repo and install dependencies:
```bash
git clone <your-repo-url>
cd WebInterview
npm install


### Option 2: Change Sets

1. Go to Setup → Deploy → Outbound Change Sets
2. Create a new change set
3. Add these components:
   - All Apex classes from `force-app/main/default/classes/`
   - All Lightning Web Components from `force-app/main/default/lwc/`
   - Custom Objects: Project__c and Invoice__c
   - Flow: Create_Invoice_on_Project_Completion
   - All custom fields
4. Upload and deploy to target org

### Option 3: Unlocked Package

Create a package:

Create package version:
```bash
sfdx force:package:version:create -p "ProjectInvoiceSystem" -d force-app -w 10
```

Install in target org:
```bash
sfdx force:package:install -p <package-version-id> -u myorg
```

## Configuration

### ERP Integration

Update the ERP endpoint in `InvoiceERPService.cls`:
```apex
private static final String ERP_ENDPOINT = 'https://your-erp-system.com/api/invoices';
```

### Flow Activation

1. Go to Setup → Process Automation → Flows
2. Find "Create Invoice on Project Completion"
3. Click Activate

### Lightning App Setup

1. Create a new Lightning App or add to existing
2. Add the Project Dashboard tab
3. Set up permissions

## Usage

### Creating Projects
1. Go to the Projects tab
2. Click "New"
3. Fill in project details
4. Set status to "In Progress"

### Managing Invoices
1. Use the Project Dashboard to view everything
2. Edit invoice amounts and payment status inline
3. Invoices are auto-created when projects are marked "Completed"

### ERP Integration
- Invoices are automatically sent to ERP when created
- Check debug logs for status
- Monitor for any errors

## Design Decisions

### Why I chose these approaches

**Separation of Concerns** - I split the logic into separate classes instead of putting everything in one place. Makes testing easier and code more maintainable.

**Future Methods for ERP** - Used `@future(callout=true)` for ERP integration to avoid governor limits. Trade-off is no immediate feedback, but it's more reliable.

**LWC over Aura** - Went with Lightning Web Components for better performance and modern standards. Requires Lightning Experience though.

**Custom Objects** - Created custom objects instead of using standard ones for flexibility. Adds some maintenance overhead but gives us exactly what we need.

**Flow for Automation** - Used Flow instead of Process Builder or triggers for the project completion logic. More user-friendly and maintainable, though less flexible than Apex.

**Trigger Handler Pattern** - Used a trigger handler class for invoice updates. Centralizes logic and makes bulk processing easier.

**Inline Editing** - Added inline editing to the dashboard for better UX. Makes data entry faster but adds some JavaScript complexity.

**Optimistic Updates** - UI updates immediately before server confirmation. Feels faster but could cause UI/server mismatches.



### Manual Testing
1. Create a project and verify fields
2. Mark project as completed and check invoice creation
3. Mark invoice as paid and verify project status update
4. Check debug logs for ERP callout
5. Test dashboard inline editing

## Troubleshooting

### Flow not triggering
- Check if flow is active
- Verify flow criteria matches project status values
- Review flow debug logs

### ERP integration failing
- Check debug logs for callout errors
- Verify ERP endpoint URL
- Make sure remote site settings are configured

### Permission errors
- Verify object and field permissions
- Check profile/permission set assignments
- Ensure Lightning Experience is enabled

### LWC not loading
- Check component metadata
- Verify Lightning App configuration
- Look at browser console for JavaScript errors

### Debug Logs
Enable debug logs:
1. Setup → Debug Logs
2. Add user or Apex class
3. Set log level to DEBUG
4. Monitor logs for errors

## Support

### Documentation
- [Lightning Web Components](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Salesforce Flow](https://help.salesforce.com/s/articleView?id=sf.flow.htm)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)

### Version Info
- API Version: 64.0
- Salesforce CLI: 7.0+
- Node.js: 14.x+

## Contributing

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

---

*Built with ❤️ for better project management*