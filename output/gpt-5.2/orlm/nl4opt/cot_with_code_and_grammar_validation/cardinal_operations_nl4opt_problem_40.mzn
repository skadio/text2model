% Parameters
int: wage_senior = 3000;
int: wage_junior = 1000;
int: min_total_accountants = 100;
int: min_senior_accountants = 5;
int: max_wage_bill = 150000;

% Variables
var 0..max_wage_bill div wage_senior: senior;
var 0..max_wage_bill div wage_junior: junior;
var 0..max_wage_bill: total_wage;

% Constraints
constraint senior + junior >= min_total_accountants;
constraint senior >= min_senior_accountants;

% senior >= (1/3)*junior  <=>  3*senior >= junior
constraint 3 * senior >= junior;

constraint total_wage = wage_senior * senior + wage_junior * junior;
constraint total_wage <= max_wage_bill;

% Objective
solve minimize total_wage;