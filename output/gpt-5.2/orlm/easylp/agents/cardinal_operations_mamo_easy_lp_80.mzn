% Parameters
int: max_hours = 20;                 % Total available hours
int: hours_per_X = 5;                % Hours required per X task
int: hours_per_Y = 3;                % Hours required per Y task

int: min_productivity = 10;          % Minimum required productivity score
int: productivity_per_X = 2;         % Productivity contribution per X task
int: productivity_per_Y = 4;         % Productivity contribution per Y task

int: cost_per_X = 50;                % Cost per X task (dollars)
int: cost_per_Y = 80;                % Cost per Y task (dollars)

% Variables
var 0..(max_hours div hours_per_X): x_tasks;  % Number of X tasks (integer, bounded by hours)
var 0..(max_hours div hours_per_Y): y_tasks;  % Number of Y tasks (integer, bounded by hours)

var 0..(cost_per_X * (max_hours div hours_per_X) + cost_per_Y * (max_hours div hours_per_Y)): total_cost;
% Total cost (bounded upper limit from max feasible task counts)

% Constraints
% Total hours capacity constraint (cannot exceed available hours)
constraint
  hours_per_X * x_tasks + hours_per_Y * y_tasks <= max_hours;

% Minimum productivity requirement constraint
constraint
  productivity_per_X * x_tasks + productivity_per_Y * y_tasks >= min_productivity;

% Define total cost based on chosen numbers of tasks
constraint
  total_cost = cost_per_X * x_tasks + cost_per_Y * y_tasks;

% Objective
solve minimize total_cost;