% Parameters
int: c1 = 5;
int: c2 = 10;
int: c3 = 7;
int: c4 = 8;

int: max12 = 100;
int: max34 = 200;
int: min13 = 50;
int: min24 = 80;

int: ub1 = 60;
int: ub2 = 50;
int: ub3 = 150;
int: ub4 = 90;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;