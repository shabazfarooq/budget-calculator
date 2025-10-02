public without sharing class BudgetAppController {

  /**
   * 
   * Remote Actions
   * 
   */
  @RemoteAction
  public static OnloadModel upsertExpense(Id sfdcId,
                                          String name,
                                          Id categoryId,
                                          Decimal amount,
                                          Boolean fixedBillPaid,
                                          Datetime dt) {
    upsert new Expense__c(
      Id = sfdcId,
      Name = name,
      Amount__c = amount,
      Category__c = categoryId,
      Datetime__c = dt,
      Fixed_Bill_Paid__c = fixedBillPaid
    );

    return getOnLoadModel();
  }

  @RemoteAction
  public static OnloadModel upsertCategory(Id sfdcId,
                                          String name,
                                          Decimal budget) {
    upsert new Category__c(
      Id = sfdcId,
      Name = name,
      Budget__c = budget
    );

    return getOnLoadModel();
  }

  @RemoteAction
  public static OnloadModel deleteExpense(Id sfdcId) {
    delete new Expense__c(Id = sfdcId);

    return getOnLoadModel();
  }

  @RemoteAction
  public static OnloadModel selectExpenseReport(Id previousActiveId, Id newActiveId) {
    update new List<Expense_Report__c>{
      new Expense_Report__c(
        Id = previousActiveId,
        Active_for_App__c = false
      ),
      new Expense_Report__c(
        Id = newActiveId,
        Active_for_App__c = true
      )
    };

    return getOnLoadModel();
  }

  @RemoteAction
  public static OnloadModel getOnloadModel() {
    // Locate Folders
    List<Expense_Report_Folder__c> expenseReportFolders = [
      SELECT 
        Id,
        Name,
        (SELECT Id, Name FROM Expense_Reports__r ORDER BY Start_Date__c DESC)
      FROM Expense_Report_Folder__c
      ORDER BY Display_Order__c ASC
    ];


    // Locate active expense report
    List<Expense_Report__c> expenseReports = [
      SELECT 
        Id,
        Name,
        Start_Date__c,
        End_Date__c,
        Active_for_App__c,
        Hide_Income__c,
        Is_Debt__c,
        Debt_Pay_Off_Per_Month_Amount__c
      FROM Expense_Report__c 
      ORDER BY Start_Date__c DESC
    ];

    // Add validation for no expense reports

    Id activeExpenseReportId;
    for (Expense_Report__c expenseReport : expenseReports) {
      if (expenseReport.Active_for_App__c == true) {
        activeExpenseReportId = expenseReport.Id;
        break;
      }
    }

    // Currently defaulting to the first expense report
    if (activeExpenseReportId == null) {
      activeExpenseReportId = expenseReports[0].Id;
    }


    // Locate categories
    List<Category__c> availableCategories = new List<Category__c>{
      new Category__c(Name = 'Select a Category')
    };

    availableCategories.addAll(
      [
        SELECT Id,
          Name,
          Budget__c,
          Fixed_Bill__c
        FROM Category__c
        WHERE Expense_Report__c =: activeExpenseReportId
        ORDER BY Display_Order__c ASC
      ]
    );

    List<Category__c> expensesByCategories = [
      SELECT Id,
        Name,
        Budget__c,
        (
        SELECT 
          Name,
          Amount__c,
          Fixed_Bill_Paid__c,
          Category__c,
          Category__r.Name,
          Category__r.Fixed_Bill__c,
          Datetime__c
        FROM Expenses__r
        ORDER BY Datetime__c ASC
        )
      FROM Category__c
      WHERE Expense_Report__c =: activeExpenseReportId
      ORDER BY Display_Order__c ASC
    ];

    List<Income__c> incomes = new List<Income__c>();
    for (Expense_Report_Income__c junction : [SELECT Id,
                                                Income__r.Id,
                                                Income__r.Name,
                                                Income__r.Income__c
                                              FROM Expense_Report_Income__c
                                              WHERE Expense_Report__c =: activeExpenseReportId]) {
      incomes.add(junction.income__r);
    }

    return new OnloadModel(
      expenseReportFolders,
      expenseReports,
      activeExpenseReportId,
      expensesByCategories,
      availableCategories,
      incomes
    );
  }




  /**
   * 
   * Inner Classes
   * 
   */
  private class OnloadModel {
    public List<Expense_Report_Folder__c> expenseReportFolders;
    public List<Expense_Report__c> expenseReports;
    public Id activeExpenseReportId;
    public List<Category__c> expensesByCategories;
    public List<Category__c> availableCategories;
    public List<Income__c> incomes;

    public OnloadModel(List<Expense_Report_Folder__c> expenseReportFolders,
                       List<Expense_Report__c> expenseReports,
                       Id activeExpenseReportId,
                       List<Category__c> expensesByCategories,
                       List<Category__c> availableCategories,
                       List<Income__c> incomes) {
      this.expenseReportFolders = expenseReportFolders;
      this.expenseReports = expenseReports;
      this.activeExpenseReportId = activeExpenseReportId;
      this.expensesByCategories = expensesByCategories;
      this.availableCategories = availableCategories;
      this.incomes = incomes;
    }
  }


}