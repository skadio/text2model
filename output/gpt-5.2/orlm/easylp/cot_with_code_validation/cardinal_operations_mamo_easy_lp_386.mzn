% Parameters
int: c1 = 50;
int: c2 = 100;
int: c3 = 70;
int: c4 = 120;

int: cap12 = 500;
int: cap34 = 300;

int: d12 = 400;   % demand threshold for (x1,x2)
int: d34 = 250;   % demand threshold for (x3,x4)

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + 4*x2 >= d12;
constraint 3*x3 + 2*x4 >= d34;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;