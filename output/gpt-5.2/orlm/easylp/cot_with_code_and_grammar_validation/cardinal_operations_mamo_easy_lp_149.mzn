% Parameters
int: min_total_goods = 50;
int: max_diff = 30;
int: costX = 20;
int: costY = 15;

% Variables
var 0..100000: X;
var 0..100000: Y;
var 0..2000000: total_cost;

% Constraints
constraint X + Y >= min_total_goods;
constraint abs(X - Y) <= max_diff;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;