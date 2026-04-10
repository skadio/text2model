% Parameters
int: max_total_employees = 100;        % Budget-driven cap on total employees
int: min_employees_X = 20;             % Minimum required in department X
int: min_employees_Y = 30;             % Minimum required in department Y
int: min_employees_Z = 10;             % Minimum required in department Z

int: cost_per_employee_X = 5000;       % Cost per employee in department X ($)
int: cost_per_employee_Y = 4000;       % Cost per employee in department Y ($)
int: cost_per_employee_Z = 6000;       % Cost per employee in department Z ($)

% Variables
var min_employees_X..max_total_employees: employees_X;  % Employees allocated to X
var min_employees_Y..max_total_employees: employees_Y;  % Employees allocated to Y
var min_employees_Z..max_total_employees: employees_Z;  % Employees allocated to Z

% Total cost in dollars (upper bounded by worst-case: all employees at max cost)
int: max_unit_cost = max([cost_per_employee_X, cost_per_employee_Y, cost_per_employee_Z]);
var 0..(max_total_employees * max_unit_cost): total_cost;

% Constraints
% Workforce cap: total employees across departments cannot exceed the maximum allowed
constraint employees_X + employees_Y + employees_Z <= max_total_employees;

% Total cost definition
constraint total_cost =
    employees_X * cost_per_employee_X +
    employees_Y * cost_per_employee_Y +
    employees_Z * cost_per_employee_Z;

% Objective
solve minimize total_cost;