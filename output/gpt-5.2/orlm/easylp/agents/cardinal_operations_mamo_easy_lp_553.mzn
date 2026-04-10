% Parameters
int: max_total_hires = 100;          % Maximum total employees that can be hired
int: min_hires_X = 30;               % Minimum employees required for position X
int: min_hires_Y = 20;               % Minimum employees required for position Y
int: min_hires_Z = 10;               % Minimum employees required for position Z

int: salary_X = 5000;                % Average salary for position X
int: salary_Y = 4000;                % Average salary for position Y
int: salary_Z = 6000;                % Average salary for position Z

% Variables
var 0..max_total_hires: hires_X;     % Number of employees hired for position X
var 0..max_total_hires: hires_Y;     % Number of employees hired for position Y
var 0..max_total_hires: hires_Z;     % Number of employees hired for position Z

var int: total_salary_cost;          % Total salary cost (objective-related)

% Constraints
% Minimum staffing requirements per position
constraint hires_X >= min_hires_X;
constraint hires_Y >= min_hires_Y;
constraint hires_Z >= min_hires_Z;

% Total hiring limit across all positions
constraint hires_X + hires_Y + hires_Z <= max_total_hires;

% Total salary cost definition (objective)
constraint total_salary_cost =
  salary_X * hires_X + salary_Y * hires_Y + salary_Z * hires_Z;

% Objective
solve minimize total_salary_cost;