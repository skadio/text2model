% Parameters
int: cost_x1 = 3;
int: cost_x2 = 2;
int: cost_x3 = 5;

int: max_total_alloc = 1000;
int: min_2x1_minus_3x3 = 500;
int: max_4x2_plus_x3 = 1200;

int: x1_max = 400;
int: x2_max = 300;
int: x3_max = 600;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total_alloc;
constraint 2*x1 - 3*x3 >= min_2x1_minus_3x3;
constraint 4*x2 + x3 <= max_4x2_plus_x3;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;