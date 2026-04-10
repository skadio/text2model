% Parameters
int: max_total_employees = 100;
int: min_employees_X = 40;
int: min_employees_Y = 20;
int: cost_per_employee_X = 50;
int: cost_per_employee_Y = 30;

% Variables
var 0..max_total_employees: employees_X;
var 0..max_total_employees: employees_Y;
var 0..(max_total_employees * max(cost_per_employee_X, cost_per_employee_Y)): total_cost;

% Constraints
constraint employees_X + employees_Y <= max_total_employees;
constraint employees_X >= min_employees_X;
constraint employees_Y >= min_employees_Y;

constraint total_cost = cost_per_employee_X * employees_X + cost_per_employee_Y * employees_Y;

% Objective
solve minimize total_cost;