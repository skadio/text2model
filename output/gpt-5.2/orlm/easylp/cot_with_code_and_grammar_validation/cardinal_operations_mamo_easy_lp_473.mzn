% Parameters
int: max_total = 200;
int: min_effect = 150;
int: max_diff = 50;
int: costX = 50;
int: costY = 80;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var int: total_cost;

% Constraints
constraint X + Y <= max_total;
constraint 2 * X + Y >= min_effect;
constraint abs(X - Y) <= max_diff;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;