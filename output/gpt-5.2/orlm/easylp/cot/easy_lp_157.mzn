% Parameters (with values embedded)
int: max_total_properties = 1000;
int: cost_X = 300000;
int: cost_Y = 200000;

% Variables
var 0..max_total_properties: X;  % number of type X properties purchased
var 0..max_total_properties: Y;  % number of type Y properties purchased
var 0..(max_total_properties * max(cost_X, cost_Y)): total_cost;

% Constraints
constraint X + Y <= max_total_properties;
constraint X >= 3 * Y;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;