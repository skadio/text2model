% Parameters
int: cap12 = 5000;
int: cap34 = 2000;

int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 20;

int: rhs2 = 100;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + 4*x2 >= x3;
constraint x2 + 3*x4 - x1 >= rhs2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;