% Parameters
int: budget_max = 50;
int: min_X = 10;
int: min_Y = 15;
int: min_Z = 5;

int: cost_X = 500;
int: cost_Y = 400;
int: cost_Z = 300;

% Variables
var min_X..budget_max: X;
var min_Y..budget_max: Y;
var min_Z..budget_max: Z;

var 0..(budget_max * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;