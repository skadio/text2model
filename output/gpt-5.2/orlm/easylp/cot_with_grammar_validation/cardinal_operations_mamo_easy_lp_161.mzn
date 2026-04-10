% Parameters
int: max_units = 10;
int: cost_residential = 50000;
int: cost_commercial = 75000;

% Weighted demand: 0.6*X + 0.4*Y >= 5
% Multiply by 10 to avoid decimals: 6*X + 4*Y >= 50
int: wX = 6;
int: wY = 4;
int: min_weighted = 50;

% Variables
var 0..max_units: X; % residential units
var 0..max_units: Y; % commercial units
var 0..(max_units * max(cost_residential, cost_commercial)): total_cost;

% Constraints
constraint X + Y <= max_units;
constraint wX * X + wY * Y >= min_weighted;

constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;