% Parameters
int: max_budget = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 50;

int: ret_X = 2;
int: ret_Y = 3;
int: ret_Z = 1;

% Variables
var min_X..max_budget: x;
var min_Y..max_budget: y;
var min_Z..max_budget: z;

var 0..max_budget: total_cost;

% Constraints
constraint x + y + z <= max_budget;

constraint total_cost = x + y + z;

% Objective
solve minimize total_cost;