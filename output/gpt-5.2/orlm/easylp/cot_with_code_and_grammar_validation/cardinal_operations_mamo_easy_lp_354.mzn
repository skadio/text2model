% Parameters
int: c1 = 20;
int: c2 = 30;
int: c3 = 10;
int: c4 = 15;

int: cap12 = 1000;     % x1 + x2 <= 1000
int: cap34 = 800;      % 2*x3 + x4 <= 800
int: min123 = 500;     % 3*x1 + 4*x2 - x3 >= 500

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint 2*x3 + x4 <= cap34;
constraint 3*x1 + 4*x2 - x3 >= min123;
constraint x2 >= 2*x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;