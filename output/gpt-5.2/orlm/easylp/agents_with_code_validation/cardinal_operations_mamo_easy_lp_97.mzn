% Parameters
int: min_total_hires = 10;             % Minimum number of employees to hire in total
int: effort_x = 3;                     % Effort coefficient for department X
int: effort_y = 4;                     % Effort coefficient for department Y
int: max_total_effort = 40;            % Maximum allowed combined effort

int: salary_x = 50000;                 % Annual salary per employee in department X (dollars)
int: salary_y = 60000;                 % Annual salary per employee in department Y (dollars)

% Variables
var 0..min_total_hires: hires_x;       % Number of hires allocated to department X (integer, nonnegative)
var 0..min_total_hires: hires_y;       % Number of hires allocated to department Y (integer, nonnegative)

var 0..(salary_x*min_total_hires + salary_y*min_total_hires): total_salary;
                                      % Total annual salary cost (dollars, integer)

% Constraints
% --- Minimum total hires requirement ---
constraint
  hires_x + hires_y >= min_total_hires;

% --- Office space / combined effort limitation ---
constraint
  effort_x * hires_x + effort_y * hires_y <= max_total_effort;

% --- Define total annual salary cost from hires allocation ---
constraint
  total_salary = salary_x * hires_x + salary_y * hires_y;

% Objective
solve minimize total_salary;