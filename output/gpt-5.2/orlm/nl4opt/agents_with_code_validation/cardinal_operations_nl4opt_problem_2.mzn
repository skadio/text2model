% Parameters
int: hours_required = 500;          % Total labor hours needed
int: budget = 15000;                % Total budget available ($)

int: hours_full_time = 8;           % Hours per full-time worker shift
int: hours_part_time = 4;           % Hours per part-time worker shift

int: cost_full_time = 300;          % Cost per full-time worker shift ($)
int: cost_part_time = 100;          % Cost per part-time worker shift ($)

% Safe upper bounds derived from requirements/budget
% Use integer arithmetic for ceil(a/b) as (a + b - 1) div b
int: max_full_time = max((hours_required + hours_full_time - 1) div hours_full_time,
                         budget div cost_full_time);
int: max_part_time = max((hours_required + hours_part_time - 1) div hours_part_time,
                         budget div cost_part_time);

% Variables
var 0..max_full_time: n_full_time;  % Number of full-time workers scheduled
var 0..max_part_time: n_part_time;  % Number of part-time workers scheduled

% Constraints

% Labor hours requirement: scheduled workers must cover at least the required hours
constraint
  hours_full_time * n_full_time + hours_part_time * n_part_time >= hours_required;

% Budget constraint: total payroll must not exceed the available budget
constraint
  cost_full_time * n_full_time + cost_part_time * n_part_time <= budget;

% Objective
solve minimize (n_full_time + n_part_time);