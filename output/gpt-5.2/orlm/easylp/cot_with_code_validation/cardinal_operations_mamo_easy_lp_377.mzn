% Parameters
int: c1 = 50;
int: c2 = 40;
int: c3 = 30;
int: c4 = 20;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Constraints
constraint x1 + x2 >= 15;
constraint x2 + x3 <= 25;
constraint x3 - x4 >= 5;
constraint x1 - 2 * x4 <= 10;

constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;