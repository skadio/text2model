% Parameters (with values embedded)
int: total_max = 1000;
int: min_excess_X_over_Y = 200;
int: cost_X = 50;
int: cost_Y = 30;
int: max_X = 700;
int: max_Y = 500;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var int: total_cost;

% Constraints
constraint X + Y <= total_max;
constraint X - Y >= min_excess_X_over_Y;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;