% Parameters
int: costX = 5;
int: costY = 3;
int: min_effectiveness = 1000;
int: max_diff = 500;

% Variables
var 0..min_effectiveness: X;
var 0..min_effectiveness: Y;
var 0..(costX*min_effectiveness + costY*min_effectiveness): total_cost;

% Constraints
constraint X + Y >= min_effectiveness;
constraint abs(X - 2*Y) <= max_diff;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;