% Parameters
int: total_employees = 100;

int: min_X = 20;
int: min_Y = 15;
int: min_Z = 10;

int: cost_X = 50;
int: cost_Y = 80;
int: cost_Z = 30;

% Variables
var min_X..total_employees: x;
var min_Y..total_employees: y;
var min_Z..total_employees: z;

var 0..(total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint x + y + z = total_employees;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;