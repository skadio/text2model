% Parameters
int: cost_res = 50000;
int: cost_com = 75000;
int: max_units = 10;

% Weighted-sum requirement: 0.6*X + 0.4*Y >= 5
% Multiply by 10 to keep integers: 6*X + 4*Y >= 50
int: w_res10 = 6;
int: w_com10 = 4;
int: min_weighted10 = 50;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..(max_units * max(cost_res, cost_com)): total_cost;

% Constraints
constraint X + Y <= max_units;
constraint w_res10 * X + w_com10 * Y >= min_weighted10;
constraint total_cost = cost_res * X + cost_com * Y;

% Objective
solve minimize total_cost;