% Parameters
int: max_total = 1000;
int: cost_X = 300000;
int: cost_Y = 200000;

% Variables
var 0..max_total: x; % number of type X properties purchased
var 0..max_total: y; % number of type Y properties purchased

% Constraints
constraint x + y <= max_total;
constraint x >= 3 * y;

% Objective
var 0..(max_total * max(cost_X, cost_Y)): total_cost;
constraint total_cost = cost_X * x + cost_Y * y;

solve minimize total_cost;