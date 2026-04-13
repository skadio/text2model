% Parameters
int: max_total_budget = 2000;          % Maximum combined allocation units for X and Y
int: min_x_offset = 500;              % X must be at least half of Y plus this offset
int: cost_x = 2;                      % Cost per unit of X
int: cost_y = 3;                      % Cost per unit of Y
int: x_lb = 0;                        % Lower bound for allocation to X
int: x_ub = 1500;                     % Upper bound for allocation to X
int: y_lb = 0;                        % Lower bound for allocation to Y
int: y_ub = 1000;                     % Upper bound for allocation to Y

% Variables
var x_lb..x_ub: x_alloc;              % Whole-number allocation to good type X
var y_lb..y_ub: y_alloc;              % Whole-number allocation to good type Y
var 0..(cost_x*x_ub + cost_y*y_ub): total_cost;  % Total cost to be minimized

% Constraints
% Total budget (combined allocation units) must not exceed the maximum
constraint
  x_alloc + y_alloc <= max_total_budget;

% Balance requirement: X must be at least half of Y plus an offset
% Integer-safe form: x >= y/2 + offset  <=>  2x >= y + 2*offset
constraint
  2 * x_alloc >= y_alloc + 2 * min_x_offset;

% Total cost definition from per-unit costs
constraint
  total_cost = cost_x * x_alloc + cost_y * y_alloc;

% Objective
solve minimize total_cost;