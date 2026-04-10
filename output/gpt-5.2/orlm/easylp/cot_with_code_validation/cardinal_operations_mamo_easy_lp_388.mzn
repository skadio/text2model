% Parameters
int: c1 = 50;
int: c2 = 100;
int: c3 = 200;
int: c4 = 300;

int: x1_min = 0;   int: x1_max = 500;
int: x2_min = 0;   int: x2_max = 400;
int: x3_min = 0;   int: x3_max = 600;
int: x4_min = 0;   int: x4_max = 700;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint x1 + x2 <= 500;
constraint x2 + x3 >= 300;
constraint abs(x3 - x4) <= 100;
constraint x4 - x1 >= 50;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;