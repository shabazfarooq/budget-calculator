trigger ExpenseReport on Expense_Report__c (after insert, after update) {

  if (Trigger.isAfter) {

    if (Trigger.isUpdate) {
      ExpenseReportServices.activateExpenseReport(Trigger.new);
    }

    if (Trigger.isInsert) {
      ExpenseReportServices.activateExpenseReport(Trigger.new);
    }

  }

}