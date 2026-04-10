% Parameters
int: max_x1 = 5000;
int: max_x2 = 4000;
int: max_x3 = 3000;
int: max_total = 10000;

int: min_effect = 2000;
int: max_balance = 1500;

int: c1 = 5000;
int: c2 = 3000;
int: c3 = 7000;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total;

% Effectiveness: 2*x1 - 3*x2 + 4.5*x3 >= 2000
% Multiply by 2 to keep integers: 4*x1 - 6*x2 + 9*x3 >= 4000
constraint 4*x1 - 6*x2 + 9*x3 >= 2*min_effect;

% Balance: (0.5*x2) - (x1 + 0.75*x3) <= 1500
% Multiply by 4 to keep integers: 2*x2 - 4*x1 - 3*x3 <= 6000
constraint 2*x2 - 4*x1 - 3*x3 <= 4*max_balance;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;