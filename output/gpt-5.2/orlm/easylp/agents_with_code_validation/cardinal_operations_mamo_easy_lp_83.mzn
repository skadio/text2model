% Parameters
int: time_per_X = 8;                 % Hours per task of type X
int: time_per_Y = 5;                 % Hours per task of type Y
int: max_total_tasks = 10;           % Maximum number of tasks (X + Y)
int: min_effectiveness = 6;          % Minimum required effectiveness score
int: eff_weight_X = 2;               % Effectiveness contribution per X
int: eff_weight_Y = 3;               % Effectiveness contribution per Y

% Variables
var 0..max_total_tasks: numX;        % Number of tasks of type X (integer, nonnegative)
var 0..max_total_tasks: numY;        % Number of tasks of type Y (integer, nonnegative)
var 0..(time_per_X * max_total_tasks): totalTime;  % Total time in hours (bounded)

% Constraints
% Link totalTime to the chosen numbers of tasks
constraint totalTime = time_per_X * numX + time_per_Y * numY;

% Resource limitation: total number of tasks cannot exceed the maximum
constraint numX + numY <= max_total_tasks;

% Business requirement: effectiveness score must meet the minimum threshold
constraint eff_weight_X * numX + eff_weight_Y * numY >= min_effectiveness;

% Objective
solve minimize totalTime;