public with sharing class ExpenseReportServices {

  // Need to bulkify
  public static void activateExpenseReport(List<Expense_Report__c> triggerNew) {
    // Determine if any new record has set make active set to true
    Expense_Report__c newActiveRecord;

    for (Expense_Report__c expenseReport : triggerNew) {
      if (expenseReport.Active_for_App__c == true) {
        newActiveRecord = expenseReport;
        break;
      }
    }

    // Exit if new records are not requesting to be active
    if (newActiveRecord == null) {
      return;
    }

    // Deactivate any other expense reports if any are active
    List<Expense_Report__c> previousActive = [
      SELECT Id
      FROM Expense_Report__c
      WHERE Active_for_App__c = true
      AND Id <>: newActiveRecord.Id
   ];

   System.debug(JSON.serialize(previousActive));

    for (Expense_Report__c expenseReport : previousActive) {
      expenseReport.Active_for_App__c = false;
    }

    // Update previous active to inactive if any exist
    if (!previousActive.isEmpty()) {
      update previousActive;
    }

  }

}