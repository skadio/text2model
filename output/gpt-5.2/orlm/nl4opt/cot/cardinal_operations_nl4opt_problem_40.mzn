% Parameters (with values embedded)
int: senior_wage = 3000;
int: junior_wage = 1000;
int: min_total_accountants = 100;
int: min_senior_accountants = 5;
int: max_weekly_wage_bill = 150000;

% Variables
var 0..max_weekly_wage_bill div senior_wage: S; % number of senior accountants
var 0..max_weekly_wage_bill div junior_wage: J; % number of junior accountants
var 0..max_weekly_wage_bill: wage_bill;

% Constraints
constraint S + J >= min_total_accountants;
constraint S >= min_senior_accountants;

% senior accountants at least a third of junior accountants: S >= (1/3)*J  <=>  3S >= J
constraint 3 * S >= J;

constraint wage_bill = senior_wage * S + junior_wage * J;
constraint wage_bill <= max_weekly_wage_bill;

% Objective
solve minimize wage_bill;