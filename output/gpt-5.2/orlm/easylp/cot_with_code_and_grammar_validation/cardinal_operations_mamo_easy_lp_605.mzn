% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: U1 = 1000;
int: U2 = 1000;
int: U3 = 1000;
int: U4 = 1000;

% Variables
var 0..U1: x1;
var 0..U2: x2;
var 0..U3: x3;
var 0..U4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x2 + x3 >= 500;

% x3 - 0.5*x4 <= 200  ==>  2*x3 - x4 <= 400
constraint 2*x3 - x4 <= 400;

% x1 >= 0.7*x4  ==>  10*x1 >= 7*x4
constraint 10*x1 >= 7*x4;

% 0.8*x2 + x3 - x1 <= 70  ==>  4*x2 + 5*x3 - 5*x1 <= 350
constraint 4*x2 + 5*x3 - 5*x1 <= 350;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;