% Parameters
int: limit_resource = 200;
int: min_ecosystem = 150;
int: max_diff = 20;

int: cost_X = 100;
int: cost_Y = 50;

% Variables
var 0..limit_resource: X;
var 0..limit_resource: Y;
var 0..(cost_X * limit_resource + cost_Y * limit_resource): total_cost;

% Constraints
constraint 2 * X + Y <= limit_resource;
constraint X + 3 * Y >= min_ecosystem;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;