% Parameters
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

int: cap_12 = 500;
int: cap_34 = 700;
int: min_13 = 200;
int: min_24 = 300;

% Variables
var 0..cap_12: x1;
var 0..cap_12: x2;
var 0..cap_34: x3;
var 0..cap_34: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

constraint x1 + x3 >= min_13;
constraint x2 + x4 >= min_24;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;