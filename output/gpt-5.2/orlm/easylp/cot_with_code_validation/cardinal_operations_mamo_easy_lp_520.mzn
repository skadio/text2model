% Parameters
int: BUDGET = 10000;
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;

int: rhs1 = 2000;
int: diff_max = 500;

% Variables
var 0..BUDGET: x1;
var 0..BUDGET: x2;
var 0..BUDGET: x3;

var 0..(c1*BUDGET + c2*BUDGET + c3*BUDGET): total_cost;

% Constraints
constraint c1*x1 + c2*x2 + c3*x3 <= BUDGET;

% (1/2)*x1 - (1/4)*x2 >= 2000  <=>  2*x1 - x2 >= 8000
constraint 2*x1 - x2 >= 4*rhs1;

% x3 - x1 <= 500
constraint x3 - x1 <= diff_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;