% Parameters
int: max_total_employees = 100;     % Budget cap on total employees across all departments

int: min_X = 20;                   % Minimum employees required in Department X
int: min_Y = 30;                   % Minimum employees required in Department Y
int: min_Z = 10;                   % Minimum employees required in Department Z

int: cost_X = 5000;                % Cost per employee in Department X (USD)
int: cost_Y = 4000;                % Cost per employee in Department Y (USD)
int: cost_Z = 6000;                % Cost per employee in Department Z (USD)

% Variables
var min_X..max_total_employees: employees_X;   % Employees assigned to Department X
var min_Y..max_total_employees: employees_Y;   % Employees assigned to Department Y
var min_Z..max_total_employees: employees_Z;   % Employees assigned to Department Z

% Total cost upper bound: all employees at the maximum per-employee cost
var 0..(max_total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
% Workforce allocation must respect the overall cap on total employees
constraint employees_X + employees_Y + employees_Z <= max_total_employees;

% Total cost is the sum of per-department costs
constraint total_cost =
    employees_X * cost_X +
    employees_Y * cost_Y +
    employees_Z * cost_Z;

% Objective
solve minimize total_cost;