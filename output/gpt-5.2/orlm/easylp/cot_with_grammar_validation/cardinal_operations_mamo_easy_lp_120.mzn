% Parameters
int: max_total = 200;
int: min_X = 50;
int: min_Y = 30;
int: cost_X = 300;
int: cost_Y = 500;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(cost_X*max_total + cost_Y*max_total): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint X >= min_X;
constraint Y >= min_Y;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;