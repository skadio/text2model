% Parameters (with values embedded)
int: min_total_resources = 100;
int: max_weighted_resources = 250;
int: cost_X = 50;
int: cost_Y = 80;

% Variables
var 0..250: X;
var 0..250: Y;
var 0..(cost_X*250 + cost_Y*250): total_cost;

% Constraints
constraint X + Y >= min_total_resources;
constraint 2*X + Y <= max_weighted_resources;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;