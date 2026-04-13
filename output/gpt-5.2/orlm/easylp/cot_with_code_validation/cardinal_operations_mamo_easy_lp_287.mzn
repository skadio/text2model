% Parameters
int: budget_max = 300;
int: min_X = 80;
int: min_Y = 60;
int: min_Z = 40;

int: cost_X = 50;
int: cost_Y = 70;
int: cost_Z = 100;

% Variables
var min_X..budget_max: X;
var min_Y..budget_max: Y;
var min_Z..budget_max: Z;

var 0..(cost_X*budget_max + cost_Y*budget_max + cost_Z*budget_max): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;