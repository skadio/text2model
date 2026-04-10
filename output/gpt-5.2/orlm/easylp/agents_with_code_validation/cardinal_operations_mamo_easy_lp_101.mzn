% Parameters
% Salary per employee per month (USD)
int: salary_X = 5000;
int: salary_Y = 8000;

% Hiring limits and requirements (employees)
int: max_total_hires = 100;
int: min_hires_X = 20;
int: min_hires_Y = 30;

% Variables
% Number of employees hired for each position (whole numbers)
var 0..max_total_hires: hires_X;
var 0..max_total_hires: hires_Y;

% Total monthly salary cost (USD)
var int: total_monthly_cost;

% Constraints
% Minimum hiring requirements per position
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;

% Total hires cannot exceed the maximum allowed
constraint hires_X + hires_Y <= max_total_hires;

% Define total monthly salary cost based on hires and salaries
constraint total_monthly_cost = salary_X * hires_X + salary_Y * hires_Y;

% Objective
solve minimize total_monthly_cost;