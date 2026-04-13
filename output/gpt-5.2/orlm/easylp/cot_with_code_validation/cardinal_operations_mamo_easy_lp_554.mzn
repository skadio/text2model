% Parameters
int: max_total_employees = 100;
int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var min_X..max_total_employees: X;
var min_Y..max_total_employees: Y;
var min_Z..max_total_employees: Z;

var 0..(max_total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_employees;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;