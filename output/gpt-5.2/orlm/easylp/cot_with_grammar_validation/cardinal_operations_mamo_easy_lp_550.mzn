% Parameters
int: total_employees = 100;
int: min_X = 30;
int: min_Y = 20;
int: min_Z = 10;

int: cost_X = 5000;
int: cost_Y = 7000;
int: cost_Z = 8000;

% Variables
var 0..total_employees: X;
var 0..total_employees: Y;
var 0..total_employees: Z;

var 0..(total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z = total_employees;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;