% Parameters
int: salary_X = 5000;                 % Salary per employee in position X (USD)
int: salary_Y = 3000;                 % Salary per employee in position Y (USD)
int: max_total_hires = 50;            % Maximum total number of employees hired
int: min_hires_X = 20;                % Minimum required employees in position X
int: max_hires_Y = 15;                % Maximum allowed employees in position Y

% Variables
var min_hires_X..max_total_hires: hires_X;   % Number of employees hired for position X
var 0..max_hires_Y: hires_Y;                 % Number of employees hired for position Y
var 0..(salary_X*max_total_hires + salary_Y*max_total_hires): total_salary_cost;
                                             % Total salary cost (USD)

% Constraints
% Total hires cannot exceed the maximum allowed
constraint hires_X + hires_Y <= max_total_hires;

% Enforce minimum hires for position X (also implied by domain, kept for clarity)
constraint hires_X >= min_hires_X;

% Enforce maximum hires for position Y (also implied by domain, kept for clarity)
constraint hires_Y <= max_hires_Y;

% Define total salary cost based on hires and salaries
constraint total_salary_cost = salary_X * hires_X + salary_Y * hires_Y;

% Objective
solve minimize total_salary_cost;

% Optional output for readability
output [
  "hires_X = ", show(hires_X), "\n",
  "hires_Y = ", show(hires_Y), "\n",
  "total_salary_cost = $", show(total_salary_cost), "\n"
];