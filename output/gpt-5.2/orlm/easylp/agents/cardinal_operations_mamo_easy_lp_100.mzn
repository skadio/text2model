% Parameters
int: max_total_employees = 100;          % Maximum employees available across both projects
int: min_employees_X = 40;              % Minimum employees required for Project X
int: min_employees_Y = 20;              % Minimum employees required for Project Y
int: cost_per_employee_X = 50;          % Cost per employee assigned to Project X ($)
int: cost_per_employee_Y = 30;          % Cost per employee assigned to Project Y ($)

% Variables
var 0..max_total_employees: employees_X; % Number of employees assigned to Project X (integer)
var 0..max_total_employees: employees_Y; % Number of employees assigned to Project Y (integer)

% Total cost ($), bounded using worst-case maximum allocation to both (safe upper bound)
var 0..(cost_per_employee_X * max_total_employees
      + cost_per_employee_Y * max_total_employees): total_cost;

% Constraints
% Employee availability constraint: total allocated across both projects cannot exceed the maximum
constraint employees_X + employees_Y <= max_total_employees;

% Minimum staffing requirements for each project
constraint employees_X >= min_employees_X;
constraint employees_Y >= min_employees_Y;

% Total cost calculation based on per-employee costs
constraint total_cost = cost_per_employee_X * employees_X
                      + cost_per_employee_Y * employees_Y;

% Objective
solve minimize total_cost;