// RegisterMonthScript.execute(2025, 10);

for (Category__c c : [SELECT Id, Name FROM Category__c WHERE Expense_Report__c = 'a04Dn00000a10QtIAI']) {
  c.Fixed_Bill__c = true;
  update c;
}