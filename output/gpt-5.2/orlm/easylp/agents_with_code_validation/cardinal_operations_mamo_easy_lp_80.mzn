% Parameters
int: total_hours_available = 20;              % Maximum total hours available
int: hours_per_task_X = 5;                    % Hours required per X task
int: hours_per_task_Y = 3;                    % Hours required per Y task

int: productivity_coef_X = 2;                 % Productivity contribution per X task
int: productivity_coef_Y = 4;                 % Productivity contribution per Y task
int: min_productivity_required = 10;          % Minimum required productivity score

int: cost_per_task_X = 50;                    % Cost per X task (dollars)
int: cost_per_task_Y = 80;                    % Cost per Y task (dollars)

% Variables
var 0..(total_hours_available div hours_per_task_X): x_tasks;  % Number of X tasks (integer)
var 0..(total_hours_available div hours_per_task_Y): y_tasks;  % Number of Y tasks (integer)

% Total cost (dollars), upper-bounded by the max possible cost under hour-based maxima
var 0..(cost_per_task_X * (total_hours_available div hours_per_task_X)
      + cost_per_task_Y * (total_hours_available div hours_per_task_Y)): total_cost;

% Constraints
% Link total_cost to the number of tasks selected
constraint total_cost = cost_per_task_X * x_tasks + cost_per_task_Y * y_tasks;

% Total hours used by tasks X and Y cannot exceed the available hours
constraint hours_per_task_X * x_tasks + hours_per_task_Y * y_tasks <= total_hours_available;

% Ensure minimum productivity requirement is satisfied
constraint productivity_coef_X * x_tasks + productivity_coef_Y * y_tasks >= min_productivity_required;

% Objective
solve minimize total_cost;