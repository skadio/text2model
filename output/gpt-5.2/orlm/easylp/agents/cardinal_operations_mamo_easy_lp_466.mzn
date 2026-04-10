% Parameters
int: salary_X = 5000;            % Salary per employee in position X (dollars)
int: salary_Y = 3000;            % Salary per employee in position Y (dollars)

int: max_total_hires = 50;       % Total hires cannot exceed this
int: min_hires_X = 20;           % At least this many employees in position X
int: max_hires_Y = 15;           % At most this many employees in position Y

% Variables
var 0..max_total_hires: hires_X; % Number of employees hired for position X
var 0..max_total_hires: hires_Y; % Number of employees hired for position Y

% Upper bound: worst case when 50 hires all at the higher salary (safe bound)
var 0..(max_total_hires * max(salary_X, salary_Y)): total_cost; % Total salary cost

% Constraints
% Hiring limit: total number of hires cannot exceed the maximum allowed
constraint hires_X + hires_Y <= max_total_hires;

% Minimum staffing requirement for position X
constraint hires_X >= min_hires_X;

% Maximum staffing limit for position Y
constraint hires_Y <= max_hires_Y;

% Define total salary cost based on hires in each position
constraint total_cost = salary_X * hires_X + salary_Y * hires_Y;

% Objective
solve minimize total_cost;