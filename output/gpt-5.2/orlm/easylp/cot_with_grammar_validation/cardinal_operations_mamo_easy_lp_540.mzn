% Parameters
int: max_total = 10;
int: c1 = 500;
int: c2 = 700;
int: c3 = 900;

% Variables
var 0..max_total: x1;
var 0..max_total: x2;
var 0..max_total: x3;

% Constraints
constraint x1 + x2 + x3 <= max_total;
constraint 5*x1 + 4*x2 >= 30;
constraint 7*x1 - 6*x3 <= 20;
constraint x2 - x1 - x3 >= 0;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3;