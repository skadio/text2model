% Parameters (with values embedded)
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 500;
int: cap34 = 300;
int: dem13 = 200;
int: dem24 = 100;

int: x1_min = 0;   int: x1_max = 250;
int: x2_min = 0;   int: x2_max = 250;
int: x3_min = 0;   int: x3_max = 150;
int: x4_min = 0;   int: x4_max = 150;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var float: total_cost = c1*int2float(x1) + c2*int2float(x2) + c3*int2float(x3) + c4*int2float(x4);

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= dem13;
constraint x2 + x4 >= dem24;

% Objective
solve minimize total_cost;