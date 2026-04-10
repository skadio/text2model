% Parameters
% Budget limit
int: total_budget = 40;

% Minimum allocations
int: min_x = 15;
int: min_y = 10;

% Maximum allocations
int: max_x = 30;
int: max_y = 20;

% Cost per unit (to minimize)
int: cost_x = 10;
int: cost_y = 5;


% Variables
% Allocation (whole numbers) to programs X and Y
var min_x..max_x: x;  % units allocated to program X
var min_y..max_y: y;  % units allocated to program Y

% Total cost (bounded for safe linear usage)
var 0..(cost_x * max_x + cost_y * max_y): total_cost;


% Constraints
% Budget feasibility: combined allocation must not exceed the available total budget
constraint
  x + y <= total_budget;

% Total cost definition: link total_cost to allocations and per-unit costs
constraint
  total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;