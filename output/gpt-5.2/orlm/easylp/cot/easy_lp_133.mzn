% Parameters (with values embedded)
int: max_total_resource = 1000;
int: coef_X = 2;
int: coef_Y = 3;
int: min_diff_X_minus_Y = 100;
int: cost_per_unit_X = 5;
int: cost_per_unit_Y = 7;

% Variables
var 0..max_total_resource: x; % integer resource units allocated to Project X
var 0..max_total_resource: y; % integer resource units allocated to Project Y
var int: total_cost;

% Constraints
constraint coef_X * x + coef_Y * y <= max_total_resource;
constraint x >= y + min_diff_X_minus_Y;

constraint total_cost = cost_per_unit_X * x + cost_per_unit_Y * y;

% Objective
solve minimize total_cost;