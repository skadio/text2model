% Parameters
int: min_total = 50;
int: max_balance = 30;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..1000: x;
var 0..1000: y;
var 0..(cost_x*1000 + cost_y*1000): total_cost;

% Constraints
constraint x + y >= min_total;
constraint 2*x - y <= max_balance;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;