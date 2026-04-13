% Parameters
int: max_total_tasks = 8;              % Maximum total number of tasks allowed
int: effort_x = 4;                     % Effort units per task X
int: effort_y = 2;                     % Effort units per task Y
int: effort_z = 3;                     % Effort units per task Z
int: min_xy_tasks = 3;                 % Minimum required combined tasks of X and Y
int: max_yz_tasks = 5;                 % Maximum allowed combined tasks of Y and Z

% Variables
var 0..max_total_tasks: num_x;         % Number of task X to schedule (integer)
var 0..max_total_tasks: num_y;         % Number of task Y to schedule (integer)
var 0..max_total_tasks: num_z;         % Number of task Z to schedule (integer)

var 0..(effort_x*max_total_tasks + effort_y*max_total_tasks + effort_z*max_total_tasks): total_effort;
                                       % Total effort (objective)

% Constraints
% Total tasks capacity constraint (cannot exceed maximum allowed tasks)
constraint num_x + num_y + num_z <= max_total_tasks;

% Minimum combined tasks of X and Y
constraint num_x + num_y >= min_xy_tasks;

% Maximum combined tasks of Y and Z
constraint num_y + num_z <= max_yz_tasks;

% Define total effort from task counts and per-task effort parameters
constraint total_effort = effort_x * num_x + effort_y * num_y + effort_z * num_z;

% Objective
solve minimize total_effort;