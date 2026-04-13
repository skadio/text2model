% Parameters
int: min_total_hires = 10;
int: max_weighted_capacity = 20; % 2*X + 1*Y <= 20
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_weighted_capacity: x; % hires in department X
var 0..max_weighted_capacity: y; % hires in department Y
var 0..(cost_X*max_weighted_capacity + cost_Y*max_weighted_capacity): total_cost;

% Constraints
constraint x + y >= min_total_hires;
constraint 2*x + y <= max_weighted_capacity;
constraint total_cost = cost_X*x + cost_Y*y;

% Objective
solve minimize total_cost;