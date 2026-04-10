% Parameters
int: wage_senior = 3000;
int: wage_junior = 1000;
int: min_total_accountants = 100;
int: min_seniors = 5;
int: max_wage_bill = 150000;

% Variables
var 0..max_wage_bill div wage_senior: seniors;
var 0..max_wage_bill div wage_junior: juniors;
var 0..max_wage_bill: wage_bill;

% Constraints
constraint wage_bill = wage_senior * seniors + wage_junior * juniors;

constraint seniors + juniors >= min_total_accountants;
constraint seniors >= min_seniors;

% seniors >= (1/3) * juniors  <=>  3*seniors >= juniors
constraint 3 * seniors >= juniors;

constraint wage_bill <= max_wage_bill;

% Objective
solve minimize wage_bill;