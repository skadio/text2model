% Parameters
int: cost1 = 300;
int: cost2 = 200;
int: cost3 = 500;
int: cost4 = 400;

int: max_x1_x2 = 1000;
int: min_2x1_plus_x3 = 800;
int: min_x2_minus_half_x4 = 300;
int: max_x2_minus_x3_minus_x1 = 70;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..(cost1*1000 + cost2*1000 + cost3*1000 + cost4*1000): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;

constraint 2*x1 + x3 >= min_2x1_plus_x3;

% 2*x2 - x4 >= 600 enforces x2 - 0.5*x4 >= 300 without fractions
constraint 2*x2 - x4 >= 2*min_x2_minus_half_x4;

constraint x2 - x3 - x1 <= max_x2_minus_x3_minus_x1;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;