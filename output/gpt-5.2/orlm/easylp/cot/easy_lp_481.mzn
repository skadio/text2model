% Parameters (with values embedded)
int: total_resource_cap = 500;
int: min_diff_X_over_Y = 100;
int: max_X = 350;
int: cost_per_unit_X = 20;
int: cost_per_unit_Y = 10;

% Variables
var 0..total_resource_cap: X;
var 0..total_resource_cap: Y;
var 0..(cost_per_unit_X*total_resource_cap + cost_per_unit_Y*total_resource_cap): total_cost;

% Constraints
constraint X + Y <= total_resource_cap;
constraint X >= Y + min_diff_X_over_Y;
constraint X <= max_X;

constraint total_cost = cost_per_unit_X * X + cost_per_unit_Y * Y;

% Objective
solve minimize total_cost;