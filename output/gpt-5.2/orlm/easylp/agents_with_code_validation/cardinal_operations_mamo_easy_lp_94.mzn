% Parameters
% Minimum total goods to distribute
int: min_total_goods = 1000;

% Capacity constraint limit for 2*X + Y
int: capacity_limit = 2500;

% Unit transport costs
int: cost_to_X = 5;
int: cost_to_Y = 3;


% Variables
% Units shipped to warehouse X (whole units, non-negative).
% From 2*x_units + y_units <= 2500 and y_units >= 0, we have x_units <= 1250.
var 0..capacity_limit div 2: x_units;

% Units shipped to warehouse Y (whole units, non-negative).
var 0..capacity_limit: y_units;

% Total transportation cost (bounded using variable upper bounds).
var 0..(cost_to_X * (capacity_limit div 2) + cost_to_Y * capacity_limit): total_cost;


% Constraints
% Ensure the total number of goods distributed meets the minimum requirement
constraint
  x_units + y_units >= min_total_goods;

% Transportation capacity constraint: doubled units to X plus units to Y cannot exceed the limit
constraint
  2 * x_units + y_units <= capacity_limit;

% Define total transportation cost from shipped units and per-unit costs
constraint
  total_cost = cost_to_X * x_units + cost_to_Y * y_units;


% Objective
solve minimize total_cost;