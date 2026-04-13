% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: ub_x1x2 = 100;
int: lb_2x1_plus_x3 = 50;
int: ub_x2_minus_3x4 = 20;
int: lb_x4_minus_half_x1 = 10;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..100000: total_cost;

% Constraints
constraint x1 + x2 <= ub_x1x2;
constraint 2 * x1 + x3 >= lb_2x1_plus_x3;
constraint x2 - 3 * x4 <= ub_x2_minus_3x4;

% x4 - 0.5*x1 >= 10  <=>  2*x4 - x1 >= 20
constraint 2 * x4 - x1 >= 2 * lb_x4_minus_half_x1;

% Define objective value
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;