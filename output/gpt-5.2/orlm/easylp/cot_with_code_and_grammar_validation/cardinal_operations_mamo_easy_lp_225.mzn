% Parameters
int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

int: x1_lb = 0;
int: x1_ub = 15;
int: x2_lb = 0;
int: x2_ub = 10;
int: x3_lb = 0;
int: x3_ub = 8;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub): total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3;

constraint 2*x1 + x2 >= 10;
constraint x1 + 3*x3 <= 20;
constraint x2 - 4*x3 >= 5;

% Objective
solve minimize total_cost;