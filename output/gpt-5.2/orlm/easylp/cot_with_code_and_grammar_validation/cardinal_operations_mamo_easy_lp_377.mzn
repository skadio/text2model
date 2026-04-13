% Parameters
int: c1 = 50;
int: c2 = 40;
int: c3 = 30;
int: c4 = 20;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 >= 15;
constraint x2 + x3 <= 25;
constraint x3 - x4 >= 5;
constraint x1 - 2 * x4 <= 10;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;