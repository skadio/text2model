% Parameters
int: total_budget = 300;
int: min_X = 80;
int: min_Y = 60;
int: min_Z = 40;

int: cost_X = 50;
int: cost_Y = 70;
int: cost_Z = 100;

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