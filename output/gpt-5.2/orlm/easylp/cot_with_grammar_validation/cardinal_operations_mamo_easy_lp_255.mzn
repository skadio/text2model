% Parameters
int: c1 = 5;
int: c2 = 4;
int: c3 = 6;

int: b12 = 100;
int: rhs2 = 150;
int: rhs3 = 200;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;

% Constraints
constraint x1 + x2 <= b12;
constraint 2 * x1 + 3 * x3 >= rhs2;
constraint 4 * x2 - x3 <= rhs3;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3;