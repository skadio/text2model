% Parameters
int: total_budget = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 120;

int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= total_budget;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;