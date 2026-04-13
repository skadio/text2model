% Parameters
int: max_total = 50;
int: min_effect = 30;
int: max_diff = 10;

int: costX = 5;
int: costY = 10;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..(costX*max_total + costY*max_total): total_cost;

% Constraints
constraint X + Y <= max_total;

constraint 2*X + Y >= min_effect;

constraint abs(X - 2*Y) <= max_diff;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;