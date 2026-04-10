% Parameters
int: total_resource_cap = 100;
int: min_impact = 300;
int: impact_X = 3;
int: impact_Y = 4;
int: max_diff = 20;
int: cost_X = 5;
int: cost_Y = 2;

% Variables
var 0..total_resource_cap: x;
var 0..total_resource_cap: y;
var 0..(cost_X * total_resource_cap + cost_Y * total_resource_cap): total_cost;

% Constraints
constraint x + y <= total_resource_cap;
constraint impact_X * x + impact_Y * y >= min_impact;
constraint abs(x - y) <= max_diff;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;