% Parameters
int: max_total_tasks = 8;              % Total number of tasks allowed
int: effort_X = 4;                     % Effort units per task X
int: effort_Y = 2;                     % Effort units per task Y
int: effort_Z = 3;                     % Effort units per task Z
int: min_X_plus_Y = 3;                 % Minimum required tasks of X+Y
int: max_Y_plus_Z = 5;                 % Maximum allowed tasks of Y+Z

% Variables
var 0..max_total_tasks: num_X;         % Number of tasks of type X
var 0..max_total_tasks: num_Y;         % Number of tasks of type Y
var 0..max_total_tasks: num_Z;         % Number of tasks of type Z

var 0..(effort_X*max_total_tasks + effort_Y*max_total_tasks + effort_Z*max_total_tasks): total_effort;
                                       % Total effort to minimize

% Constraints
% Total tasks capacity: cannot exceed the overall limit
constraint num_X + num_Y + num_Z <= max_total_tasks;

% Minimum requirement: X + Y must be at least the specified minimum
constraint num_X + num_Y >= min_X_plus_Y;

% Coupled limit: Y + Z cannot exceed the specified maximum
constraint num_Y + num_Z <= max_Y_plus_Z;

% Define total effort as the weighted sum of tasks by effort per task
constraint total_effort = effort_X * num_X + effort_Y * num_Y + effort_Z * num_Z;

% Objective
solve minimize total_effort;