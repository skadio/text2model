% Parameters
int: total_resource_cap = 500;
int: min_diff_X_over_Y = 100;
int: max_X = 350;

int: cost_X = 20;
int: cost_Y = 10;

% Variables
var 0..max_X: X;
var 0..total_resource_cap: Y;
var 0..(cost_X*max_X + cost_Y*total_resource_cap): total_cost;

% Constraints
constraint X + Y <= total_resource_cap;
constraint X >= Y + min_diff_X_over_Y;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;