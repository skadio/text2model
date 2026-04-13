% Parameters
int: total_budget = 50;
int: min_X = 10;
int: min_Y = 15;
int: min_Z = 5;

int: cost_X = 500;
int: cost_Y = 400;
int: cost_Z = 300;

% Variables
var min_X..total_budget: X;
var min_Y..total_budget: Y;
var min_Z..total_budget: Z;

var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;