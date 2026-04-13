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

% Scale weighted constraint by 10 to avoid floats:
% 0.5x1 + 0.6x2 - 0.7x3 + 0.8x4 <= 15
% => 5x1 + 6x2 - 7x3 + 8x4 <= 150
constraint 5*x1 + 6*x2 - 7*x3 + 8*x4 <= 150;

% Objective
var int: total_workload = w1*x1 + w2*x2 + w3*x3 + w4*x4;
solve minimize total_workload;