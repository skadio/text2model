% Parameters (with values embedded)
int: max_budget = 2000;
int: cost_X = 50;
int: cost_Y = 100;
int: min_diff = 500;

% Variables
var 0..max_budget: X;  % integer budget/effort units allocated to channel X
var 0..max_budget: Y;  % integer budget/effort units allocated to channel Y
var 0..(cost_X*max_budget + cost_Y*max_budget): total_cost;

% Constraints
constraint X + Y <= max_budget;
constraint 3 * X - 2 * Y >= min_diff;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;