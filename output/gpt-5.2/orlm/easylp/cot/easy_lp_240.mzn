% Parameters (with values embedded)
int: max_total_resources = 20;
int: min_feasibility = 5;
int: max_quality_diff = 10;

int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 150;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

var 0..(max_total_resources * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_resources;
constraint 2 * X + Y >= min_feasibility;
constraint Y - Z <= max_quality_diff;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;