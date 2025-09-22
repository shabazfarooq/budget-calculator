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
        Budget__c = 3780.80,
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
        Name = 'Electric (Chase) (adjust)',
        Datetime__c = DateTime.newInstance(year, month, 6, 6, 5, 0),
        Amount__c = 237.39,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Water/Trash (Cap1) (adjust)',
        Datetime__c = DateTime.newInstance(year, month, 10, 6, 5, 0),
        Amount__c = 155.00,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Parents Grass (Chase)',
        Datetime__c = DateTime.newInstance(year, month, 11, 6, 5, 0),
        Amount__c = 200,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Tmobile (Chase)',
        Datetime__c = DateTime.newInstance(year, month, 12, 20, 22, 0),
        Amount__c = 174.82,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Car Insurance (Cap1)',
        Datetime__c = DateTime.newInstance(year, month, 16, 6, 5, 0),
        Amount__c = 176.71,
        Category__c = bills.Id
    ),
    new Expense__c(
        Name = 'Internet (Amex)',
        Datetime__c = DateTime.newInstance(year, month, 18, 6, 5, 0),
        Amount__c = 90.78,
        Category__c = bills.Id
    )
  };
    
    // Debt -- Create category and related expenses
    Category__c debt = new Category__c(
        Name = 'Debt',
        Display_Order__c = 1,
        Expense_Report__c = er.Id,
        Budget__c = 1764.41,
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
            Name = 'Zara - Private (Chase)',
            Datetime__c = DateTime.newInstance(year, month, 23, 6, 5, 0),
            Amount__c = 300,
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
        Budget__c = 84.56,
        Fixed_Bill__c = true
    );
    insert subscriptions;
    
    insert new List<Expense__c>{
        new Expense__c(
            Name = 'iCloud Zara (Zara Amex)',
            Datetime__c = DateTime.newInstance(year, month, 4, 4, 5, 0),
            Amount__c = 9.99,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'YouTube (Zara Amex)',
            Datetime__c = DateTime.newInstance(year, month, 8, 6, 5, 0),
            Amount__c = 32.46,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Hulu (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 16, 6, 5, 0),
            Amount__c = 10.86,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Hulu Credit (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 17, 6, 5, 0),
            Amount__c = -10,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = 'Netflix (Free w/ Tmobile)',
            Datetime__c = DateTime.newInstance(year, month, 18, 6, 5, 0),
            Amount__c = 0,
            Category__c = subscriptions.Id
        ),
        new Expense__c(
            Name = '2-10 Home Buyers (Amex)',
            Datetime__c = DateTime.newInstance(year, month, 29, 6, 5, 0),
            Amount__c = 41.25,
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
    
    // insert new List<Expense__c>{
    //     new Expense__c(
    //         Name = 'Ted tobacco',
    //         Datetime__c = DateTime.newInstance(year, month, 26, 23, 4, 0),
    //         Amount__c = 100,
    //         Category__c = cigarettes.Id
    //     )
    // };

    
    // Gas -- Create category and related expenses
    Category__c gas = new Category__c(
        Name = 'Gas',
        Display_Order__c = 4,
        Expense_Report__c = er.Id,
        Budget__c = 300
    );
    insert gas;
    
    // Tolls -- Create category and related expenses
    Category__c tolls = new Category__c(
        Name = 'Tolls',
        Display_Order__c = 5,
        Expense_Report__c = er.Id,
        Budget__c = 200
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
        Budget__c = 500
    );
    insert funMoney;
    
    // Medical -- Create category and related expenses
    Category__c medical = new Category__c(
        Name = 'Medical',
        Display_Order__c = 8,
        Expense_Report__c = er.Id,
        Budget__c = 75
    );
    insert medical;
    
    // Donation -- Create category and related expenses
    Category__c donation = new Category__c(
        Name = 'Donation',
        Display_Order__c = 9,
        Expense_Report__c = er.Id,
        Budget__c = 116.9,
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
        Budget__c = 500
    );
    insert cat;
    
    // Unexpected -- Create category and related expenses
    Category__c unexpected = new Category__c(
        Name = 'Unexpected',
        Display_Order__c = 11,
        Expense_Report__c = er.Id,
        Budget__c = 0
    );
    insert unexpected;
    
    // Expense Reimbursement -- Create category and related expenses
    Category__c AdditionalIncome = new Category__c(
        Name = 'Additional Income',
        Display_Order__c = 12,
        Expense_Report__c = er.Id,
        Budget__c = -50
    );
    insert AdditionalIncome;
    
    insert new List<Expense__c>{
        new Expense__c(
            Name = 'Internet',
            Datetime__c = DateTime.newInstance(year, month, 1, 2, 16, 0),
            Amount__c = -50,
            Category__c = AdditionalIncome.Id
        )
    };
  }
}