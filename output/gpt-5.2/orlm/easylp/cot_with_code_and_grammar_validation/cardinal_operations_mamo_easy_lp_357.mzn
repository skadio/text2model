% Parameters
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 500;
int: cap34 = 300;
int: dem13 = 200;
int: dem24 = 100;

int: lb1 = 0; int: ub1 = 250;
int: lb2 = 0; int: ub2 = 250;
int: lb3 = 0; int: ub3 = 150;
int: lb4 = 0; int: ub4 = 150;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var float: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= dem13;
constraint x2 + x4 >= dem24;

constraint total_cost = c1*int2float(x1) + c2*int2float(x2) + c3*int2float(x3) + c4*int2float(x4);

% Objective
solve minimize total_cost;