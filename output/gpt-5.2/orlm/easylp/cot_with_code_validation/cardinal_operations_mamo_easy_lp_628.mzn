% Parameters
int: salary_x1 = 5000;
int: salary_x2 = 4000;
int: salary_x3 = 6000;
int: salary_x4 = 7000;

int: max_x1 = 50;
int: max_x2 = 60;
int: max_x3 = 40;
int: max_x4 = 40;

int: cap_x1_x2 = 100;
int: cap_x3_x4 = 80;

int: balance_limit = 30;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(salary_x1*max_x1 + salary_x2*max_x2 + salary_x3*max_x3 + salary_x4*max_x4): total_cost;

% Constraints
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% x1 >= 20 + 0.5*x3  <=>  2*x1 >= 40 + x3
constraint 2 * x1 >= 40 + x3;

constraint abs(x4 - x2) <= balance_limit;

constraint total_cost = salary_x1*x1 + salary_x2*x2 + salary_x3*x3 + salary_x4*x4;

% Objective
solve minimize total_cost;