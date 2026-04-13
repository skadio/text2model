% Parameters (with values embedded)
int: max_total_resources = 100;
int: min_effectiveness = 20;
int: cost_X = 2;
int: cost_Y = 3;

% Variables
var 0..max_total_resources: X; % allocation to emergency
var 0..max_total_resources: Y; % allocation to surgery

% Constraints
constraint X + Y <= max_total_resources;
constraint 1 * X + 1 * Y >= min_effectiveness;

% Objective
solve minimize cost_X * X + cost_Y * Y;