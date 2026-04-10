% Parameters
int: total_employees = 20;
int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

int: min_X = 5;
int: min_Y = 3;
int: min_Z = 2;

% Variables
var 0..total_employees: x;
var 0..total_employees: y;
var 0..total_employees: z;

var 0..(total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint x + y + z = total_employees;

constraint x >= min_X;
constraint y >= min_Y;
constraint z >= min_Z;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;