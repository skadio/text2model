% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: ub12 = 1000;
int: rhs34 = 500;
int: ub14 = 1200;
int: ub23 = 300;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..600: x3;
var 0..600: x4;

var 0..10000000: total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2 * x3 + x4 >= rhs34;
constraint x1 + 3 * x4 <= ub14;
constraint x2 - 2 * x3 <= ub23;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;