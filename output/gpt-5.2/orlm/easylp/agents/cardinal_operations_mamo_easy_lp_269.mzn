% Parameters
int: max_total_hires = 100;            % Maximum total hires across all categories
int: min_hires_X = 20;                % Minimum hires for category X
int: min_hires_Y = 30;                % Minimum hires for category Y
int: min_hires_Z = 10;                % Minimum hires for category Z

int: salary_X = 50000;                % Salary per employee in category X (dollars)
int: salary_Y = 70000;                % Salary per employee in category Y (dollars)
int: salary_Z = 90000;                % Salary per employee in category Z (dollars)

% Variables
var min_hires_X..max_total_hires: hires_X;   % Number of hires in category X
var min_hires_Y..max_total_hires: hires_Y;   % Number of hires in category Y
var min_hires_Z..max_total_hires: hires_Z;   % Number of hires in category Z

% Total salary cost (dollars), bounded above by worst-case (all categories at max_total_hires)
var 0..(salary_X*max_total_hires + salary_Y*max_total_hires + salary_Z*max_total_hires): total_salary_cost;

% Constraints
% Total hires must not exceed the overall maximum
constraint
  hires_X + hires_Y + hires_Z <= max_total_hires;

% Define total salary cost as the sum of category-wise salary expenses
constraint
  total_salary_cost =
    salary_X * hires_X +
    salary_Y * hires_Y +
    salary_Z * hires_Z;

% Objective
solve minimize total_salary_cost;