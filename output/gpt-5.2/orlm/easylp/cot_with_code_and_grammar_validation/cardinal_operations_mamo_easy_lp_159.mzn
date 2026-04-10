% Parameters
int: max_units = 1000;
int: min_diversity = 500;
int: max_diff = 200;

int: costX = 200;
int: costY = 300;

% Variables
var 0..max_units: x;
var 0..max_units: y;

var 0..(costX*max_units + costY*max_units): total_cost;

% Constraints
constraint x + y <= max_units;
constraint 2*x + y >= min_diversity;
constraint abs(x - y) <= max_diff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;