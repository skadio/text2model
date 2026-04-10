% Parameters
int: x1_max = 300;
int: x2_max = 200;
int: x3_max = 500;
int: x4_max = 700;

int: sum12_eq = 400;
int: sum34_max = 1000;

int: c1 = 20;
int: c2 = 15;
int: c3 = 10;
int: c4 = 5;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint x1 + x2 = sum12_eq;
constraint x3 + x4 <= sum34_max;
constraint x3 + x4 >= x1 + x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;