% Parameters
int: nTasks = 4;                                   % Number of tasks
set of int: TASKS = 1..nTasks;                     % Task index set: 1=X1, 2=X2, 3=X3, 4=X4

int: maxHours = 24;                                % Max hours per task (whole hours)
array[TASKS] of int: costPerHour = [3, 4, 5, 6];   % Hourly costs for X1..X4

int: min_X1_X2 = 10;                               % X1 + X2 >= 10
int: max_X2_X3 = 20;                               % X2 + X3 <= 20
int: minDiff_X1_X4 = 5;                            % X1 - X4 >= 5
int: maxDiff_X3_X4 = 10;                           % X3 - X4 <= 10

% Variables
array[TASKS] of var 0..maxHours: hours;            % Scheduled whole hours for each task (X1..X4)
var 0..(maxHours * sum(costPerHour)): totalCost;   % Total cost in dollars (safe upper bound)

% Constraints
% Link total cost to chosen hours
constraint totalCost = sum(t in TASKS)(costPerHour[t] * hours[t]);

% --- Task-hour relationship constraints (given scheduling rules) ---

% Minimum combined hours for X1 and X2
constraint hours[1] + hours[2] >= min_X1_X2;

% Maximum combined hours for X2 and X3
constraint hours[2] + hours[3] <= max_X2_X3;

% X1 must have at least 5 more hours than X4
constraint hours[1] - hours[4] >= minDiff_X1_X4;

% X3 must have at most 10 more hours than X4
constraint hours[3] - hours[4] <= maxDiff_X3_X4;

% Objective
solve minimize totalCost;