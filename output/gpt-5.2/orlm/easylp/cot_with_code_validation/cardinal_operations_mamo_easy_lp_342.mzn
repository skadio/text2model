% Parameters
int: c1 = 10;
int: c2 = 9;
int: c3 = 11;
int: c4 = 12;

int: max12 = 500;
int: max34 = 400;
int: min13 = 300;
int: min24 = 600;

% Variables
var 0..1000000: x1;
var 0..1000000: x2;
var 0..1000000: x3;
var 0..1000000: x4;

var 0..1000000000: total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;