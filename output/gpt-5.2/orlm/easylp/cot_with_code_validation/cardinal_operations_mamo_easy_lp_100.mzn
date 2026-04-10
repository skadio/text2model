% Parameters
int: max_total_employees = 100;
int: min_x = 40;
int: min_y = 20;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var min_x..max_total_employees: x;
var min_y..max_total_employees: y;
var 0..(cost_x * max_total_employees + cost_y * max_total_employees): total_cost;

% Constraints
constraint x + y <= max_total_employees;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;