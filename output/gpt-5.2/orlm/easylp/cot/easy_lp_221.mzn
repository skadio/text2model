% Parameters (with values embedded)
int: max_budget = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 50;

int: return_X = 2;
int: return_Y = 3;
int: return_Z = 1;

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;
var 0..max_budget: Z;

var 0..max_budget: total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= max_budget;

constraint total_cost = X + Y + Z;

% Objective
solve minimize total_cost;