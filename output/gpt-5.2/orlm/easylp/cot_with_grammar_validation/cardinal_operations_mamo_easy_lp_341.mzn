% Parameters
int: c1 = 5;
int: c2 = 10;
int: c3 = 7;
int: c4 = 8;

int: max12 = 100;
int: max34 = 200;
int: min13 = 50;
int: min24 = 80;

int: x1_max = 60;
int: x2_max = 50;
int: x3_max = 150;
int: x4_max = 90;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;