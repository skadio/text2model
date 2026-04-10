% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: ub_x1x2 = 100;
int: rhs_2x1_x3 = 150;
int: ub_x2_3x4 = 50;
int: lb_x3_minus_x4 = 20;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..1000000: total_cost;

% Constraints
constraint x1 + x2 <= ub_x1x2;
constraint 2*x1 + x3 >= rhs_2x1_x3;
constraint x2 - 3*x4 <= ub_x2_3x4;
constraint x3 - x4 >= lb_x3_minus_x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;