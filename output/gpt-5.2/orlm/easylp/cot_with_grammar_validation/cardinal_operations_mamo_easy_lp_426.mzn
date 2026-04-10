% Parameters
int: costX = 50;
int: costY = 75;
int: cap_total = 1200;
int: min_gap = 300;
int: storage_cap = 2000;

% Variables
var 0..cap_total: x;
var 0..cap_total: y;
var 0..(costX*cap_total + costY*cap_total): total_cost;

% Constraints
constraint x + y <= cap_total;
constraint x - y >= min_gap;
constraint 2*x + y <= storage_cap;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;