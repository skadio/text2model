% Parameters (with values embedded)
int: max_total_resources = 100;
int: min_total_resources = 30;
int: min_effectiveness = 200;   % 2*X + 3*Y must be at least 200
int: cost_X = 4;
int: cost_Y = 5;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..(cost_X*max_total_resources + cost_Y*max_total_resources): total_cost;

% Constraints
constraint X + Y <= max_total_resources;
constraint X + Y >= min_total_resources;
constraint 2*X + 3*Y >= min_effectiveness;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;