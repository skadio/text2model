% Parameters
int: total_employees = 100;
int: min_x = 30;
int: min_y = 20;
int: min_z = 10;

int: cost_x = 5000;
int: cost_y = 7000;
int: cost_z = 8000;

% Variables
var min_x..total_employees: x;
var min_y..total_employees: y;
var min_z..total_employees: z;

var 0..(total_employees * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z = total_employees;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;