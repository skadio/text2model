% Parameters (with values embedded)
int: min_total_programs = 30;
int: cost_X = 4;
int: cost_Y = 3;
int: diff_limit = 10;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000000: total_cost;

% Constraints
constraint X + Y >= min_total_programs;
constraint 2 * X - Y <= diff_limit;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;