% Parameters (with values embedded)
int: c1 = 6;
int: c2 = 7;
int: c3 = 5;
int: c4 = 4;

% Variables
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

% Constraints
constraint x1 + x2 <= 8;
constraint x3 >= x4 + 3;
constraint 2*x1 + x2 - 2*x3 <= 12;          % x1 + 0.5*x2 - x3 <= 6
constraint x2 + 2*x4 - 2*x1 >= 0;           % 0.5*x2 + x4 - x1 >= 0

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;