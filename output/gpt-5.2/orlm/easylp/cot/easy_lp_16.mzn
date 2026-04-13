% Parameters (with values embedded)
int: min_total_allocation = 50;
int: max_balance = 30; % for constraint 2*X - Y <= 30
int: cost_X = 4;
int: cost_Y = 3;

% Variables
var 0..100000: X;
var 0..100000: Y;
var 0..1000000: total_cost;

% Constraints
constraint X + Y >= min_total_allocation;
constraint 2*X - Y <= max_balance;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;