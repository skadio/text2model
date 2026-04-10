% Parameters
int: max_total_hires = 100;          % Total hiring limit
int: min_hires_X = 30;              % Minimum hires for position X
int: min_hires_Y = 20;              % Minimum hires for position Y
int: min_hires_Z = 10;              % Minimum hires for position Z

int: salary_X = 5000;               % Average salary for position X
int: salary_Y = 4000;               % Average salary for position Y
int: salary_Z = 6000;               % Average salary for position Z

% Variables
var 0..max_total_hires: hires_X;    % Number of employees hired for position X
var 0..max_total_hires: hires_Y;    % Number of employees hired for position Y
var 0..max_total_hires: hires_Z;    % Number of employees hired for position Z

% Total salary cost (upper bound uses the maximum possible salary per hire)
var 0..(max_total_hires * max(salary_X, max(salary_Y, salary_Z))): total_salary_cost;

% Constraints
% Hiring minimum requirements (feasibility constraints)
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;
constraint hires_Z >= min_hires_Z;

% Total hiring limit (budget/capacity constraint)
constraint hires_X + hires_Y + hires_Z <= max_total_hires;

% Define total salary cost (linking/definition constraint)
constraint total_salary_cost =
  salary_X * hires_X + salary_Y * hires_Y + salary_Z * hires_Z;

% Objective
solve minimize total_salary_cost;