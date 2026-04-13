% Parameters
int: min_total_programs = 30;          % Minimum required total number of programs (X + Y)
int: max_diff = 10;                   % Maximum allowed value of (2*X - Y)
int: cost_X = 4;                      % Cost per X program
int: cost_Y = 3;                      % Cost per Y program

% Variables
var 0..min_total_programs: x;         % Number of X programs (non-negative integer)
var 0..min_total_programs: y;         % Number of Y programs (non-negative integer)
var 0..(cost_X*min_total_programs + cost_Y*min_total_programs): total_cost;  % Total cost

% Constraints
% Minimum total number of programs
constraint
  x + y >= min_total_programs;

% Balance constraint: difference between twice X and Y must not exceed max_diff
constraint
  2 * x - y <= max_diff;

% Define total cost from program counts and per-program costs
constraint
  total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;