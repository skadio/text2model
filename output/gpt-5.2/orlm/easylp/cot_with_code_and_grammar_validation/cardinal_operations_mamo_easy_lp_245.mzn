% Parameters
int: x1_lb = 0;
int: x1_ub = 24;
int: x2_lb = 0;
int: x2_ub = 12;
int: x3_lb = 0;
int: x3_ub = 30;

int: c1 = 5;
int: c2 = 6;
int: c3 = 3;

% Variables
var x1_lb..x1_ub: X1;
var x2_lb..x2_ub: X2;
var x3_lb..x3_ub: X3;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub): total_cost;

% Constraints
constraint 2*X1 + 3*X2 + 1*X3 >= 10;
constraint 4*X1 + 5*X2 + 2*X3 <= 20;
constraint 1*X1 - 2*X2 + 1*X3 >= 8;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;