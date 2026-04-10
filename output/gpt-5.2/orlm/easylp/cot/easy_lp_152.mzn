% Parameters (with values embedded)
int: cost_X = 50;
int: cost_Y = 70;
int: max_total = 1000;
int: min_X = 300;
int: min_Y = 200;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(cost_X*max_total + cost_Y*max_total): total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint X + Y <= max_total;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;