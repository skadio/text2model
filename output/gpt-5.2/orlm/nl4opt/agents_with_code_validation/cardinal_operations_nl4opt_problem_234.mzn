% Parameters
int: part_time_hours = 15;          % Hours worked per part-time staff per week
int: full_time_hours = 40;          % Hours worked per full-time staff per week
int: part_time_pay = 450;           % Weekly pay per part-time staff (dollars)
int: full_time_pay = 1280;          % Weekly pay per full-time staff (dollars)
int: required_hours = 1000;         % Total labor hours required
int: budget = 31500;               % Total budget available (dollars)

% Upper bounds derived from requirements/budget (safe integer bounds)
int: max_part_time_by_hours = required_hours div part_time_hours;
int: max_full_time_by_hours = required_hours div full_time_hours;
int: max_part_time_by_budget = budget div part_time_pay;
int: max_full_time_by_budget = budget div full_time_pay;

% Use a safe upper bound (max) from either limiting factor
int: max_part_time = max(max_part_time_by_hours, max_part_time_by_budget);
int: max_full_time = max(max_full_time_by_hours, max_full_time_by_budget);

% Variables
var 0..max_part_time: n_part_time;  % Number of part-time staff to hire
var 0..max_full_time: n_full_time;  % Number of full-time staff to hire

% Constraints

% Meet or exceed the required total labor hours
constraint
  part_time_hours * n_part_time + full_time_hours * n_full_time >= required_hours;

% Stay within the available budget
constraint
  part_time_pay * n_part_time + full_time_pay * n_full_time <= budget;

% Objective
solve minimize n_part_time + n_full_time;