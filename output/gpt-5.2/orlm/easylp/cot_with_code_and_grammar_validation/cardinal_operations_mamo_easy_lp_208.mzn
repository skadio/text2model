% Parameters
int: budget_invest = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 100;

int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 20;

% Variables
var 0..budget_invest: X;
var 0..budget_invest: Y;
var 0..budget_invest: Z;

var 0..(cost_X*budget_invest + cost_Y*budget_invest + cost_Z*budget_invest): total_cost;

% Constraints
constraint X + Y + Z <= budget_invest;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;