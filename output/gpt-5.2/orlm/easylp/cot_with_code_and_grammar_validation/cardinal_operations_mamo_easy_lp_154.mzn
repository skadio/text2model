% Parameters
int: max_shipments = 1000;
int: min_units = 1500;
int: diff_X_ge_Y = 200;
int: cost_X = 50;
int: cost_Y = 70;

% Variables
var 0..max_shipments: x; % shipments on Route X
var 0..max_shipments: y; % shipments on Route Y
var 0..(cost_X*max_shipments + cost_Y*max_shipments): total_cost;

% Constraints
constraint x + y <= max_shipments;
constraint 2*x + 3*y >= min_units;
constraint x >= y + diff_X_ge_Y;

constraint total_cost = cost_X*x + cost_Y*y;

% Objective
solve minimize total_cost;