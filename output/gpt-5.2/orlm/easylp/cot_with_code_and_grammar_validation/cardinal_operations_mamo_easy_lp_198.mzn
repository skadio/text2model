% Parameters
int: total_budget = 5000;

int: min_X = 1000;
int: max_Y = 3000;
int: min_Z = 500;

int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 50;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;
var 0..total_budget: z;

var 0..(total_budget * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint x + y + z <= total_budget;

constraint x >= min_X;
constraint y <= max_Y;
constraint z >= min_Z;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;