% Parameters
int: min_total = 100;
int: a = 5;
int: b = -2;
int: max_lin = 50;
int: costX = 10;
int: costY = 20;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..30000: total_cost;

% Constraints
constraint X + Y >= min_total;
constraint a * X + b * Y <= max_lin;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;