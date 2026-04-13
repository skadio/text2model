% Parameters
int: hours_required = 500;            % Total labor hours required
int: budget = 15000;                  % Total budget available (dollars)

int: hours_per_full_time = 8;         % Hours worked per full-time worker per shift
int: hours_per_part_time = 4;         % Hours worked per part-time worker per shift

int: cost_per_full_time = 300;        % Cost per full-time worker per shift (dollars)
int: cost_per_part_time = 100;        % Cost per part-time worker per shift (dollars)

% Upper bounds derived from budget (safe finite bounds)
int: max_full_time = budget div cost_per_full_time;
int: max_part_time = budget div cost_per_part_time;

% Variables
var 0..max_full_time: num_full_time;  % Number of full-time workers to schedule
var 0..max_part_time: num_part_time;  % Number of part-time workers to schedule

% Constraints

% Labor-hours coverage: scheduled workers must provide at least the required hours
constraint
  hours_per_full_time * num_full_time + hours_per_part_time * num_part_time >= hours_required;

% Budget limit: total wage cost must not exceed the available budget
constraint
  cost_per_full_time * num_full_time + cost_per_part_time * num_part_time <= budget;

% Objective
solve minimize (num_full_time + num_part_time);