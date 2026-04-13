% Parameters
int: w1 = 10;
int: w2 = 15;
int: w3 = 20;
int: w4 = 25;

int: cap12 = 12;
int: cap34 = 16;
int: min13 = 8;
int: min24 = 10;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(w1*cap12 + w2*cap12 + w3*cap34 + w4*cap34): total_fatigue;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_fatigue = w1*x1 + w2*x2 + w3*x3 + w4*x4;

% Objective
solve minimize total_fatigue;