% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 12;
int: c4 = 20;

int: max12 = 8;
int: max34 = 10;
int: min13 = 5;
int: min24 = 6;

% (No explicit per-variable bounds were provided beyond integrality and nonnegativity)
int: U = max(max12, max34);  % safe upper bound for each variable

% Variables
var 0..U: x1;
var 0..U: x2;
var 0..U: x3;
var 0..U: x4;

var 0..(c1*U + c2*U + c3*U + c4*U): fatigue;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize fatigue;