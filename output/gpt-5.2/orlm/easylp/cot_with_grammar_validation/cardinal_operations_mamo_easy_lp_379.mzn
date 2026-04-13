% Parameters
int: w1 = 30;
int: w2 = 40;
int: w3 = 50;
int: w4 = 60;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 >= 10;
constraint x2 + x3 <= 20;
constraint x3 >= x4 + 5;

% 0.5 x1 + 0.6 x2 - 0.7 x3 + 0.8 x4 <= 15
% Multiply by 10 to keep integer linear form:
% 5 x1 + 6 x2 - 7 x3 + 8 x4 <= 150
constraint 5*x1 + 6*x2 - 7*x3 + 8*x4 <= 150;

% Objective
solve minimize w1*x1 + w2*x2 + w3*x3 + w4*x4;