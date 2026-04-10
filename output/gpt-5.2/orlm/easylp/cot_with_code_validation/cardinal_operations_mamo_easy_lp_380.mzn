% Parameters
int: f1 = 10;
int: f2 = 15;
int: f3 = 20;
int: f4 = 25;

int: cap12 = 12;
int: cap34 = 16;
int: min13 = 8;
int: min24 = 10;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(f1*cap12 + f2*cap12 + f3*cap34 + f4*cap34): total_fatigue;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_fatigue = f1*x1 + f2*x2 + f3*x3 + f4*x4;

% Objective
solve minimize total_fatigue;