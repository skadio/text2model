% Parameters (with values embedded)
int: x1_min = 0;   int: x1_max = 400;
int: x2_min = 0;   int: x2_max = 300;
int: x3_min = 50;  int: x3_max = 200;
int: x4_min = 30;  int: x4_max = 60;

float: c1 = 0.5;
float: c2 = 0.3;
float: c3 = 0.4;
float: c4 = 0.6;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var float: total_cost;

% Constraints
constraint x1 + x2 <= 500;
constraint 2*x1 + 3*x3 >= 300;
constraint x4 - (x2 / 2.0) <= 100.0;
constraint x2 + x4 - x1 - x3 = 80;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;