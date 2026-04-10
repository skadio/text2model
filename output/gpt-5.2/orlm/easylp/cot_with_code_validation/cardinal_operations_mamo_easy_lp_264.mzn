% Parameters
int: total_cap = 200;
int: min_X = 50;
int: min_Y = 30;
int: min_Z = 20;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var min_X..total_cap: x;
var min_Y..total_cap: y;
var min_Z..total_cap: z;

var 0..(total_cap * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint x + y + z <= total_cap;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;