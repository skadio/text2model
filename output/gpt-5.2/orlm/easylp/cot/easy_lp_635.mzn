% Parameters (with values embedded)
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

int: max_x1_x2 = 500;
int: max_x3_x4 = 700;
int: min_x1_x3 = 200;
int: min_x2_x4 = 300;

% Variables
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;
constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;