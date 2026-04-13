% Parameters
int: c1 = 5;
int: c2 = 10;
int: c3 = 7;
int: c4 = 8;

int: cap12 = 100;
int: cap34 = 200;
int: dem13 = 50;
int: dem24 = 80;

int: x1_ub = 60;
int: x2_ub = 50;
int: x3_ub = 150;
int: x4_ub = 90;

% Variables
var 0..x1_ub: x1;
var 0..x2_ub: x2;
var 0..x3_ub: x3;
var 0..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= dem13;
constraint x2 + x4 >= dem24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;