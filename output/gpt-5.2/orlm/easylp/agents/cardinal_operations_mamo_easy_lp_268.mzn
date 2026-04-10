% Parameters
int: max_total_employees = 100;          % Maximum total employees allowed across all departments
int: cost_X = 5000;                      % Average cost per employee in department X
int: cost_Y = 4000;                      % Average cost per employee in department Y
int: cost_Z = 6000;                      % Average cost per employee in department Z
int: z_excess_limit = 10;                % Z cannot exceed (3/4 of X) by more than this amount

% Variables
var 0..max_total_employees: employees_X; % Number of employees allocated to department X
var 0..max_total_employees: employees_Y; % Number of employees allocated to department Y
var 0..max_total_employees: employees_Z; % Number of employees allocated to department Z

% Upper bound uses the maximum unit cost times the max number of employees
var 0..(max_total_employees * max([cost_X, cost_Y, cost_Z])): total_cost; % Total cost to minimize

% Constraints
% Total employees capacity constraint (office space / managerial capacity)
constraint
  employees_X + employees_Y + employees_Z <= max_total_employees;

% Staffing relationship: X should be at least twice the half of Y (i.e., X >= Y)
constraint
  employees_X >= employees_Y;

% Supervisory capacity: Z cannot exceed (3/4 of X) by more than z_excess_limit
% Integer-safe form to avoid fractional coefficients: 4*Z <= 3*X + 4*limit
constraint
  4 * employees_Z <= 3 * employees_X + 4 * z_excess_limit;

% Total cost definition (integer arithmetic)
constraint
  total_cost = cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;

% Objective
solve minimize total_cost;