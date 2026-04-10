% Parameters
% Minimum total employees required across both projects
int: min_total_employees = 20;

% Resource limit: 2*X + 1*Y <= max_resource
int: max_resource = 40;

% Daily cost per employee assigned to each project
int: cost_per_employee_X = 50;
int: cost_per_employee_Y = 80;

% Upper bounds derived from constraints to keep variables bounded
% From 2*X + Y <= 40 and non-negativity:
% X <= 20, Y <= 40
int: max_employees_X = 20;
int: max_employees_Y = 40;

% Variables
% Number of employees assigned to Project X (integer, non-negative, bounded)
var 0..max_employees_X: employees_X;

% Number of employees assigned to Project Y (integer, non-negative, bounded)
var 0..max_employees_Y: employees_Y;

% Total daily cost (integer, bounded)
var 0..(cost_per_employee_X * max_employees_X + cost_per_employee_Y * max_employees_Y): total_daily_cost;

% Constraints
% Manpower requirement: total employees across both projects must be at least the minimum
constraint employees_X + employees_Y >= min_total_employees;

% Resource limitation: twice Project X employees plus Project Y employees cannot exceed limit
constraint 2 * employees_X + employees_Y <= max_resource;

% Cost definition: total daily cost equals sum of per-project daily costs
constraint total_daily_cost =
  cost_per_employee_X * employees_X +
  cost_per_employee_Y * employees_Y;

% Objective
solve minimize total_daily_cost;