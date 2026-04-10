% Parameters
int: min_total_programs = 30;
int: max_diff = 10;
int: cost_X = 4;
int: cost_Y = 3;

% Variables
var 0..min_total_programs: x;
var 0..min_total_programs: y;
var 0..(cost_X*min_total_programs + cost_Y*min_total_programs): total_cost;

% Constraints
constraint x + y >= min_total_programs;
constraint 2 * x - y <= max_diff;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;