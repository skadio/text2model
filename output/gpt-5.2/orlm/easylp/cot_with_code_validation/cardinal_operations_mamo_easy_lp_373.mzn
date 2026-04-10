% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: cap12 = 500;
int: cap34 = 400;

int: dem13 = 350;
int: dem24 = 300;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= dem13;
constraint x2 + x4 >= dem24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;