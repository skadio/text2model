% Parameters
int: c1 = 200;
int: c2 = 300;
int: c3 = 400;
int: c4 = 500;

int: cap12 = 1000;
int: cap34 = 1200;
int: min_total = 500;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;
var 0..1200: x4;

var 0..1000000000: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint 2 * x3 + x4 <= cap34;
constraint x1 + x2 + x3 + x4 >= min_total;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;