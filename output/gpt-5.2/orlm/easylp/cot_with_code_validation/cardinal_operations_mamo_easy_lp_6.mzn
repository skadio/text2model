% Parameters
int: costX = 5;
int: costY = 3;
int: min_effectiveness = 1000;
int: max_diff = 500;

% Variables
var 0..min_effectiveness: X;
var 0..min_effectiveness: Y;

% Constraints
constraint X + Y >= min_effectiveness;
constraint abs(X - 2*Y) <= max_diff;

% Objective
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;