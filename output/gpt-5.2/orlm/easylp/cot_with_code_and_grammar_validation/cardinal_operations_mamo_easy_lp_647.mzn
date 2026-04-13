% Parameters
int: c1 = 300;
int: c2 = 200;
int: c3 = 500;
int: c4 = 400;

int: ub12 = 1000;
int: rhs_2x1_plus_x3 = 800;
int: rhs_x2_minus_half_x4 = 300;
int: rhs_x2_minus_x3_minus_x1 = 70;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= ub12;

constraint 2 * x1 + x3 >= rhs_2x1_plus_x3;

% x2 - 0.5*x4 >= 300  <=>  2*x2 - x4 >= 600
constraint 2 * x2 - x4 >= 2 * rhs_x2_minus_half_x4;

constraint x2 - x3 - x1 <= rhs_x2_minus_x3_minus_x1;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;