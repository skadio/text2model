% Parameters
int: max_total_employees = 100;         % Maximum total employees across all departments
int: cost_X = 5000;                     % Average cost per employee in department X
int: cost_Y = 4000;                     % Average cost per employee in department Y
int: cost_Z = 6000;                     % Average cost per employee in department Z
int: z_excess_limit = 10;               % Z cannot exceed (3/4 of X) by more than this amount

% Variables
var 0..max_total_employees: employees_X;  % Number of employees allocated to department X
var 0..max_total_employees: employees_Y;  % Number of employees allocated to department Y
var 0..max_total_employees: employees_Z;  % Number of employees allocated to department Z

% Upper bound: in worst case all employees in max-cost department
var 0..(max_total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
% Total employees capacity constraint
constraint employees_X + employees_Y + employees_Z <= max_total_employees;

% Staffing relationship: "X at least twice the half of Y" => X >= Y (integer-safe)
constraint employees_X >= employees_Y;

% Supervisory capacity constraint for Z relative to X:
% Z <= (3/4) * X + z_excess_limit  <=>  4Z <= 3X + 4*z_excess_limit
constraint 4 * employees_Z <= 3 * employees_X + 4 * z_excess_limit;

% Total cost calculation constraint
constraint total_cost = cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;

% Objective
solve minimize total_cost;