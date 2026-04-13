% Parameters (with values embedded)
int: max_total_employees = 100;
int: min_x = 40;
int: min_y = 20;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var 0..max_total_employees: employees_x;
var 0..max_total_employees: employees_y;
var int: total_cost;

% Constraints
constraint employees_x + employees_y <= max_total_employees;
constraint employees_x >= min_x;
constraint employees_y >= min_y;

constraint total_cost = cost_x * employees_x + cost_y * employees_y;

% Objective
solve minimize total_cost;