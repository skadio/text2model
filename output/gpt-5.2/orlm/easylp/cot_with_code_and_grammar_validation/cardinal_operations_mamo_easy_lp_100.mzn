% Parameters
int: max_total_employees = 100;
int: min_x = 40;
int: min_y = 20;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var 0..max_total_employees: x_employees;
var 0..max_total_employees: y_employees;
var 0..(max_total_employees * max(cost_x, cost_y)): total_cost;

% Constraints
constraint x_employees + y_employees <= max_total_employees;
constraint x_employees >= min_x;
constraint y_employees >= min_y;

constraint total_cost = cost_x * x_employees + cost_y * y_employees;

% Objective
solve minimize total_cost;