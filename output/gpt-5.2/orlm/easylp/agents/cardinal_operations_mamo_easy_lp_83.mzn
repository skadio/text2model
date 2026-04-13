% Parameters
int: time_per_X = 8;                % hours per task of type X
int: time_per_Y = 5;                % hours per task of type Y
int: max_total_tasks = 10;          % maximum allowed total number of tasks (X + Y)
int: eff_coeff_X = 2;               % effectiveness coefficient for X
int: eff_coeff_Y = 3;               % effectiveness coefficient for Y
int: min_effectiveness = 6;         % minimum required effectiveness score

% Variables
var 0..max_total_tasks: num_X;      % number of tasks of type X (integer, nonnegative)
var 0..max_total_tasks: num_Y;      % number of tasks of type Y (integer, nonnegative)
var 0..(time_per_X*max_total_tasks + time_per_Y*max_total_tasks): total_time; % total time in hours

% Constraints
% Task count limit (resource constraint)
constraint
  num_X + num_Y <= max_total_tasks;

% Minimum effectiveness requirement
constraint
  eff_coeff_X * num_X + eff_coeff_Y * num_Y >= min_effectiveness;

% Total time definition (links decision variables to total_time)
constraint
  total_time = time_per_X * num_X + time_per_Y * num_Y;

% Objective
solve minimize total_time;