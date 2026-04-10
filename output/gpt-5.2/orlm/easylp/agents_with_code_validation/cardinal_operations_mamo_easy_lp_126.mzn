% Parameters
int: min_total_programs = 30;          % Minimum total number of programs (X + Y)
int: max_diff_2x_minus_y = 10;         % Upper bound on (2*X - Y)
int: cost_x = 4;                       % Cost per X program
int: cost_y = 3;                       % Cost per Y program

% Variables
var 0..min_total_programs + max_diff_2x_minus_y: x_programs;              % # of X programs (integer, non-negative)
var 0..2 * (min_total_programs + max_diff_2x_minus_y): y_programs;        % # of Y programs (integer, non-negative)
var 0..(cost_x * (min_total_programs + max_diff_2x_minus_y)
      + cost_y * 2 * (min_total_programs + max_diff_2x_minus_y)): total_cost; % Total cost

% Constraints
% Ensure a substantial total number of programs are organized
constraint x_programs + y_programs >= min_total_programs;

% Maintain balance: twice X minus Y must not exceed the allowed maximum difference
constraint 2 * x_programs - y_programs <= max_diff_2x_minus_y;

% Define total cost based on the number of each program type
constraint total_cost = cost_x * x_programs + cost_y * y_programs;

% Objective
solve minimize total_cost;