% Parameters (with values embedded)
int: max_total_allocation = 200;
int: min_total_allocation = 50;
int: cost_X = 5;
int: cost_Y = 8;

% Variables
var 0..max_total_allocation: X;
var 0..max_total_allocation: Y;
var 0..(cost_X*max_total_allocation + cost_Y*max_total_allocation): total_cost;

% Constraints
constraint X + Y <= max_total_allocation;
constraint X + Y >= min_total_allocation;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;