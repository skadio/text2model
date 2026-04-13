% Parameters
int: min_total_programs = 30;
int: diff_limit = 10;
int: cost_X = 4;
int: cost_Y = 3;

% Variables
var 0..min_total_programs: X;
var 0..min_total_programs: Y;
var 0..(cost_X*min_total_programs + cost_Y*min_total_programs): total_cost;

% Constraints
constraint X + Y >= min_total_programs;
constraint 2*X - Y <= diff_limit;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;