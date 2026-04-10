% Parameters
int: max_total_hires = 100;                 % Maximum total number of hires allowed
int: min_hires_X = 20;                      % Minimum required hires for category X
int: min_hires_Y = 30;                      % Minimum required hires for category Y
int: min_hires_Z = 10;                      % Minimum required hires for category Z

int: salary_X = 50000;                      % Salary per employee in category X (dollars)
int: salary_Y = 70000;                      % Salary per employee in category Y (dollars)
int: salary_Z = 90000;                      % Salary per employee in category Z (dollars)

% Variables
var min_hires_X..max_total_hires: hires_X;  % Number of hires in category X
var min_hires_Y..max_total_hires: hires_Y;  % Number of hires in category Y
var min_hires_Z..max_total_hires: hires_Z;  % Number of hires in category Z

% Total salary cost upper bound uses worst-case salary for all hires
var 0..(max_total_hires * max(salary_X, max(salary_Y, salary_Z))): total_salary_cost;

% Constraints
% Total hires must not exceed the overall hiring cap
constraint
  hires_X + hires_Y + hires_Z <= max_total_hires;

% Compute total salary cost from category-wise hires and salaries
constraint
  total_salary_cost = salary_X * hires_X + salary_Y * hires_Y + salary_Z * hires_Z;

% Objective
solve minimize total_salary_cost;