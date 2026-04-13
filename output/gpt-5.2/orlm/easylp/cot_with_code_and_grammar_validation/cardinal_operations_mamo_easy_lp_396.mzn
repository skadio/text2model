% Parameters
int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;
int: cost4 = 5;

int: limit12 = 1000;
int: min34 = 500;
int: limit14 = 1200;
int: limit23 = 300;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..600: x4;

var 0..10000000: total_cost;

% Constraints
constraint x1 + x2 <= limit12;
constraint 2*x3 + x4 >= min34;
constraint x1 + 3*x4 <= limit14;
constraint x2 - 2*x3 <= limit23;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;