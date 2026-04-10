% Parameters (with values embedded)
int: c1 = 300;
int: c2 = 200;
int: c3 = 500;
int: c4 = 400;

int: ub12 = 1000;
int: rhs2 = 800;
int: rhs3 = 300;
int: rhs4 = 70;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..2000: x4;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2*x1 + x3 >= rhs2;

% x2 - 0.5*x4 >= 300  <=>  2*x2 - x4 >= 600
constraint 2*x2 - x4 >= 2*rhs3;

% x2 - x3 - x1 <= 70
constraint x2 - x3 - x1 <= rhs4;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;