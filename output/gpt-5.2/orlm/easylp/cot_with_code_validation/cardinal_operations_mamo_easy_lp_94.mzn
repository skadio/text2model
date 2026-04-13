% Parameters
int: min_total = 1000;
int: cap = 2500;
int: costX = 5;
int: costY = 3;

% Variables
var 0..cap: x;
var 0..cap: y;
var 0..(costX * cap + costY * cap): total_cost;

% Constraints
constraint x + y >= min_total;
constraint 2 * x + y <= cap;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;