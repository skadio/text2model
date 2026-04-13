% Parameters
int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

int: ub12 = 200;
int: rhs2 = 150;
int: rhs3 = 75;
int: rhs4 = 100;

% Variables
var 0..200: x1;
var 0..200: x2;
var 0..200: x3;
var 0..200: x4;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2*x1 + 3*x3 >= rhs2;
constraint x4 - 2*x1 <= 2*rhs3;
constraint 2*x3 + x4 - 2*x2 >= 2*rhs4;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;