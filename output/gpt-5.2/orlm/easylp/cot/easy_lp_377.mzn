% Parameters (with values embedded)
int: cost_x1 = 50;
int: cost_x2 = 40;
int: cost_x3 = 30;
int: cost_x4 = 20;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..1000000: total_cost;

% Constraints
constraint x1 + x2 >= 15;
constraint x2 + x3 <= 25;
constraint x3 >= x4 + 5;
constraint x1 - 2 * x4 <= 10;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;