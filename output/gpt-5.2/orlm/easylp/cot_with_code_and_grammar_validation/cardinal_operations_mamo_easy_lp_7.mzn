% Parameters
int: max_resources = 5000;
int: min_effectiveness = 10000;

int: eff_x = 2;
int: eff_y = 3;

int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..max_resources: X;
var 0..max_resources: Y;

var 0..(cost_x * max_resources + cost_y * max_resources): total_cost;

% Constraints
constraint X + Y <= max_resources;

constraint eff_x * X + eff_y * Y >= min_effectiveness;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;