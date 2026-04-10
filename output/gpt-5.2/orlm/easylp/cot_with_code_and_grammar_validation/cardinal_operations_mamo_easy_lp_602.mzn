% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: ub12 = 1000;
int: min_service = 500;
int: max_diff31 = 200;
int: min_gap42 = 150;

% Variables
var 0..ub12: x1;
var 0..ub12: x2;
var 0..2000: x3;
var 0..2000: x4;

var 0..20000: total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2 * x1 + 3 * x2 >= min_service;
constraint x3 - x1 <= max_diff31;
constraint x1 - x3 <= max_diff31;
constraint x4 >= x2 + min_gap42;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;