% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

% Variables
var 0..50: x1;
var 0..50: x2;
var 0..60: x3;
var 0..50: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 50;
constraint x3 >= x4 + 10;
constraint 2 * x1 + x3 <= 60;
constraint x2 >= 2 * x4 + 5;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;