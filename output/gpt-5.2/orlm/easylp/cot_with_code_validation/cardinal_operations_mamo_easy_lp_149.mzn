% Parameters
int: min_total_goods = 50;
int: max_diff = 30;
int: cost_x = 20;
int: cost_y = 15;

% Variables
var 0..100000: X;
var 0..100000: Y;
var 0..2000000: total_cost;

% Constraints
constraint X + Y >= min_total_goods;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;