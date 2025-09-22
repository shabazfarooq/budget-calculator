@RestResource(urlMapping='/BudgetAPI/Onload/*')
global class BudgetAPI_Onload {

  /**
   * 
   * 
   * HTTP Endpoint: POST
   * 
   * 
   */
  @HttpPost
  global static OnloadModel upsertExpense(Id sfdcId,
                                          String name,
                                          Id categoryId,
                                          Decimal amount,
                                          Datetime dt) {
    
    upsert new Expense__c(
      Id = sfdcId,
      Name = name,
      Amount__c = amount,
      Category__c = categoryId,
      Datetime__c = dt
    );

    return getOnLoadModel();
  }

  /**
   * 
   * 
   * HTTP Endpoint: DELETE
   * 
   * 
   */
  @HttpDelete
  global static OnloadModel upsertExpense() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String expenseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    if (String.isNotBlank(expenseId)) {
      delete [SELECT Id FROM Expense__c WHERE Id =: expenseId];
    }

    return getOnLoadModel();
  }


  /**
   * 
   * 
   * HTTP Endpoint: GET
   * 
   * 
   */
  @HttpGet
  global static OnloadModel getOnloadModel() {
    // Build individual models
    List<ExpensesByCategory> expensesByCategory = build_expensesByCategory();
    Decimal income = getIncome();
    List<Category> categories = getCategories();

    // Return Onload model
    return new OnloadModel(expensesByCategory, income, categories);
  }


  /**
   * 
   * 
   * Helper methods
   * 
   * 
   */
  private static List<ExpensesByCategory> build_expensesByCategory() {
    // Query records
    List<Category__c> queryRecords = [
      SELECT Id,
        Name,
        Budget__c,
        (
        SELECT 
          Name,
          Amount__c,
          Category__c,
          Category__r.Name,
          Datetime__c
        FROM Expenses__r
        ORDER BY Datetime__c ASC
        )
      FROM Category__c
      ORDER BY Display_Order__c ASC
    ];

    // Build ExpensesByCategory model
    List<ExpensesByCategory> model = new List<ExpensesByCategory>();

    for (Category__c category : queryRecords) {
      model.add(new ExpensesByCategory(category));
    }

    return model;
  }

  private static Decimal getIncome() {
    Decimal totalIncome = 0.0;

    for (Income__c i : [SELECT Id, Name, Income__c FROM Income__c]) {
      totalIncome += i.Income__c;
    }

    return totalIncome;
  }

  private static List<Category> getCategories() {
    List<Category> model = new List<Category>();

    for (Category__c c :[SELECT Id,
                           Name,
                           Budget__c,
                           Fixed_Bill__c
                         FROM Category__c
                         ORDER BY Display_Order__c ASC]) {
      model.add(new Category(c));
    }

    return model;
  }

  /**
   * 
   * 
   * Onload Model
   * 
   * 
   */
  global class OnloadModel {
    public List<ExpensesByCategory> expensesByCategory;
    public Decimal income;
    public List<Category> categories;

    public OnloadModel(List<ExpensesByCategory> expensesByCategory,
                       Decimal income,
                       List<Category> categories) {
      this.expensesByCategory = expensesByCategory;
      this.income = income;
      this.categories = categories;
    }
  }


  /**
   * 
   * 
   * Expense
   * 
   * 
   */
  global class ExpensesByCategory {
    public Id id;
    public String name;
    public Decimal budget;
    public List<Expense> expenses;

    public ExpensesByCategory(Category__c c) {
      this.id = c.Id;
      this.name = c.Name;
      this.budget = c.Budget__c;
      this.expenses = new List<Expense>();

      for (Expense__c e : c.Expenses__r) {
        this.expenses.add(new Expense(e));
      }
    }
  }

  global class Expense {
    public Id id;
    public String name;
    public Decimal amount;
    public String dt;

    public Expense(Expense__c e) {
      this.id = e.Id;
      this.name = e.Name;
      this.amount = e.Amount__c;
      this.dt = getUTCDatetimeString(e.Datetime__c);
    }

    public String getUTCDatetimeString(Datetime dt){
      //2020-05-30T23:32:27Z
      return dt.formatGMT('yyyy-MM-d\'T\'HH:mm:ssZ');
    }
  }


  /**
   * 
   * 
   * Category
   * 
   * 
   */
  global class Category {
    private Id id;
    private String name;
    private Decimal budget;

    global Category(Category__c c) {
      this.id = c.Id;
      this.name = c.Name;
      this.budget = c.Budget__c;
    } 
  }


  ///**
  // * 
  // * 
  // * Expense
  // * 
  // * 
  // */
  //global class Income {
  //  public Decimal amount;

  //  public Income(Income__c i) {
  //    this.amount = i.Income__c;
  //  }
  //}

}