% Parameters (with values embedded)
int: min_total_hours = 10;
int: max_weighted_hours = 24;
int: weight_X = 2;
int: weight_Y = 3;
int: cost_X = 8;
int: cost_Y = 5;

% Variables
var 0..max_weighted_hours: X;  % integer hours for task X
var 0..max_weighted_hours: Y;  % integer hours for task Y
var 0..(cost_X*max_weighted_hours + cost_Y*max_weighted_hours): total_cost;

% Constraints
constraint X + Y >= min_total_hours;
constraint weight_X * X + weight_Y * Y <= max_weighted_hours;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;