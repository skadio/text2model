% Parameters
int: max_resources = 100;
int: min_impact = 300;

int: impact_x = 3;
int: impact_y = 4;

int: cost_x = 5;
int: cost_y = 2;

int: max_diff = 20;

% Variables
var 0..max_resources: x;
var 0..max_resources: y;
var 0..(cost_x * max_resources + cost_y * max_resources): total_cost;

% Constraints
constraint x + y <= max_resources;
constraint impact_x * x + impact_y * y >= min_impact;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;