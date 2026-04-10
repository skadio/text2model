% Parameters
int: max_total = 1000;
int: min_weighted = 500;
int: max_diff = 200;

int: costX = 5;
int: costY = 10;

% Variables
var 0..max_total: x;
var 0..max_total: y;

var 0..(costX*max_total + costY*max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_weighted;
constraint abs(x - 2*y) <= max_diff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;