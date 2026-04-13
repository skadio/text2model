% Parameters
int: total_budget = 5000;

int: min_X = 1000;
int: max_Y = 3000;
int: min_Z = 500;

int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 50;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint X >= min_X;
constraint Y <= max_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;