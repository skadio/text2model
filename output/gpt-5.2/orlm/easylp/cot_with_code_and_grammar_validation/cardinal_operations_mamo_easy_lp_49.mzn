% Parameters
int: max_total_resources = 50;
int: min_effectiveness = 30;
int: max_balance_diff = 10;

int: cost_X = 5;
int: cost_Y = 10;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;

var 0..(cost_X*max_total_resources + cost_Y*max_total_resources): total_cost;

% Constraints
constraint X + Y <= max_total_resources;

constraint 2*X + Y >= min_effectiveness;

constraint abs(X - 2*Y) <= max_balance_diff;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;