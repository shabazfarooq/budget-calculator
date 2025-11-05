public with sharing class RegisterMonthScript {
  public static void execute(Integer year, Integer month) {
    // Build variables
    Date startDate = Date.newInstance(year, month, 01);
    Date endDate = startDate.addMonths(1).addDays(-1);
    List<String> monthShort = new List<String>{
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    };
    
    // Create new Expense Report
    Expense_Report__c er = new Expense_Report__c(
      Name = monthShort[month-1] + ' ' + String.valueOf(startDate.year()),
      Expense_Report_Folder__c = [SELECT Id FROM Expense_Report_Folder__c WHERE Name = 'Monthly Expenses' LIMIT 1].Id,
      Active_for_App__c = true,
      Start_Date__c = startDate,
      End_Date__c = endDate
    );
    insert er;

    // Insert Expense Report Incomes
    insert new List<Expense_Report_Income__c>{
        new Expense_Report_Income__c(
            Expense_Report__c = er.Id,
            Income__c = 'a02Dn00000BeXYFIA3'
        ),
        new Expense_Report_Income__c(
            Expense_Report__c = er.Id,
            Income__c = 'a02Dn00000BeXYAIA3'
        )
    };

    
    // Bills -- Create category and related expenses
    Category__c bills = new Category__c(
        Name = 'Bills',
        Display_Order__c = 0,
        Expense_Report__c = er.Id,
        Budget__c = 3707.82,
        Fixed_Bill__c = true
    );
    insert bills;

    insert new List<Expense__c>{
    new Expense__c(
        Name = 'Mortgage (Chase)',
        Datetime__c = DateTime.newInstance(year, month, 1, 6, 0, 0),
        Amount__c = 2746.10,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Parents Grass (Chase) (adjust)',
        Datetime__c = DateTime.newInstance(year, month, 1, 6, 5, 0),
        Amount__c = 200,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Electric (Chase) (adjust)',
        Datetime__c = DateTime.newInstance(year, month, 5, 6, 5, 0),
        Amount__c = 200,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Tmobile (Chase)',
        Datetime__c = DateTime.newInstance(year, month, 10, 20, 22, 0),
        Amount__c = 186.72,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Water/Trash (Cap1) (adjust)',
        Datetime__c = DateTime.newInstance(year, month, 15, 6, 5, 0),
        Amount__c = 110,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Car Insurance (Cap1)',
        Datetime__c = DateTime.newInstance(year, month, 16, 6, 5, 0),
        Amount__c = 170.62,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Att Internet (Amex)',
        Datetime__c = DateTime.newInstance(year, month, 17, 6, 5, 0),
        Amount__c = 90.78,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Alta Pest Control',
        Datetime__c = DateTime.newInstance(year, month, 24, 6, 5, 0),
        Amount__c = 0,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'HOA (Clickpay) ($118.45)',
        Datetime__c = DateTime.newInstance(year, month, 30, 6, 5, 0),
        Amount__c = 0,
        Category__c = bills.Id
    )
  };
    
    // Debt -- Create category and related expenses
    Category__c debt = new Category__c(
        Name = 'Debt',
        Display_Order__c = 1,
        Expense_Report__c = er.Id,
        Budget__c = 1464.41,
        Fixed_Bill__c = true
    );
    insert debt;
    
    insert new List<Expense__c>{
        new Expense__c(
            Name = '401k Loan Repayment (Chase) (ends: Nov 2, 2026)',
            Datetime__c = DateTime.newInstance(year, month, 2, 6, 5, 0),
            Amount__c = 281.29,
            Category__c = debt.Id
        ),
        new Expense__c(
            Name = 'Zara - Public (Nelnet) (Chase)',
            Datetime__c = DateTime.newInstance(year, month, 5, 6, 5, 0),
            Amount__c = 162.87,
            Category__c = debt.Id
        ),
        new Expense__c(
            Name = 'VW Car (Chase)',
            Datetime__c = DateTime.newInstance(year, month, 16, 6, 5, 0),
            Amount__c = 730.24,
            Category__c = debt.Id
        ),
        new Expense__c(
            Name = 'SSDI - (Zara Amex) (21,813.60)',
            Datetime__c = DateTime.newInstance(year, month, 17, 6, 5, 0),
            Amount__c = 75,
            Category__c = debt.Id
        ),
        new Expense__c(
            Name = 'Shabaz - (Aidvantage) (Chase)',
            Datetime__c = DateTime.newInstance(year, month, 27, 6, 5, 0),
            Amount__c = 215.01,
            Category__c = debt.Id
        )
    };

    // Subscriptions -- Create category and related expenses
    Category__c subscriptions = new Category__c(
        Name = 'Subscriptions',
        Display_Order__c = 2,
        Expense_Report__c = er.Id,
        Budget__c = 72.61,
        Fixed_Bill__c = true
    );
    insert subscriptions;
    
    insert new List<Expense__c>{
        new Expense__c(
            Name = 'iCloud (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 4, 4, 5, 0),
            Amount__c = 9.99,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'YouTube (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 4, 6, 5, 0),
            Amount__c = 22.99,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'YouTube Credit (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 9, 7, 5, 0),
            Amount__c = -25,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Netflix (0|11 w/ Tmobile)',
            Datetime__c = DateTime.newInstance(year, month, 10, 6, 5, 0),
            Amount__c = 11,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Hulu (0|18 w/ Tmobile)',
            Datetime__c = DateTime.newInstance(year, month, 10, 6, 5, 0),
            Amount__c = 0,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Car Wash (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 19, 6, 5, 0),
            Amount__c = 30,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'ChatGPT (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 28, 6, 5, 0),
            Amount__c = 21.64,
            Category__c = subscriptions.Id
        )
    };
    
    // Cigarettes -- Create category and related expenses
    Category__c cigarettes = new Category__c(
        Name = 'Cigarettes',
        Display_Order__c = 3,
        Expense_Report__c = er.Id,
        Budget__c = 100
    );
    insert cigarettes;    
    
    // Gas -- Create category and related expenses
    Category__c gas = new Category__c(
        Name = 'Gas',
        Display_Order__c = 4,
        Expense_Report__c = er.Id,
        Budget__c = 250
    );
    insert gas;
    
    // Tolls -- Create category and related expenses
    Category__c tolls = new Category__c(
        Name = 'Tolls',
        Display_Order__c = 5,
        Expense_Report__c = er.Id,
        Budget__c = 100
    );
    insert tolls;
    
    // Grocery -- Create category and related expenses
    Category__c grocery = new Category__c(
        Name = 'Grocery',
        Display_Order__c = 6,
        Expense_Report__c = er.Id,
        Budget__c = 1000
    );
    insert grocery;
    
    // Fun Money -- Create category and related expenses
    Category__c funMoney = new Category__c(
        Name = 'Fun Money',
        Display_Order__c = 7,
        Expense_Report__c = er.Id,
        Budget__c = 1000
    );
    insert funMoney;
    
    // Medical -- Create category and related expenses
    Category__c medical = new Category__c(
        Name = 'Medical',
        Display_Order__c = 8,
        Expense_Report__c = er.Id,
        Budget__c = 100
    );
    insert medical;
    
    // Donation -- Create category and related expenses
    Category__c donation = new Category__c(
        Name = 'Donation',
        Display_Order__c = 9,
        Expense_Report__c = er.Id,
        Budget__c = 300,
        Fixed_Bill__c = true
    );
    insert donation;
    
    insert new List<Expense__c>{
        new Expense__c(
            Name = 'IRUSA (Delta)',
            Datetime__c = DateTime.newInstance(year, month, 13, 2, 56, 0),
            Amount__c = 86,
            Category__c = donation.Id
        ),
        new Expense__c(
            Name = 'Amoud Foundation (Zara Amex)',
            Datetime__c = DateTime.newInstance(year, month, 16, 6, 5, 0),
            Amount__c = 30.9,
            Category__c = donation.Id
        )
    };
    
    // Cat -- Create category and related expenses
    Category__c cat = new Category__c(
        Name = 'Cat',
        Display_Order__c = 10,
        Expense_Report__c = er.Id,
        Budget__c = 350
    );
    insert cat;
    
    // Unexpected -- Create category and related expenses
    Category__c unexpected = new Category__c(
        Name = 'Unexpected',
        Display_Order__c = 11,
        Expense_Report__c = er.Id,
        Budget__c = 500
    );
    insert unexpected;
    
    // Expense Reimbursement -- Create category and related expenses
    Category__c AdditionalIncome = new Category__c(
        Name = 'Additional Income',
        Display_Order__c = 12,
        Expense_Report__c = er.Id,
        Budget__c = 0
    );
    insert AdditionalIncome;
    
    // insert new List<Expense__c>{
    //     new Expense__c(
    //         Name = 'Internet',
    //         Datetime__c = DateTime.newInstance(year, month, 1, 2, 16, 0),
    //         Amount__c = -50,
    //         Category__c = AdditionalIncome.Id
    //     )
    // };
  }
}