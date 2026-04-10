% Parameters
int: total_budget = 100;

int: min_X = 30;
int: min_Y = 20;
int: min_Z = 10;

int: cost_X = 20;
int: cost_Y = 15;
int: cost_Z = 10;

% Variables
var min_X..total_budget: x;
var min_Y..total_budget: y;
var min_Z..total_budget: z;

var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
constraint x + y + z <= total_budget;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;