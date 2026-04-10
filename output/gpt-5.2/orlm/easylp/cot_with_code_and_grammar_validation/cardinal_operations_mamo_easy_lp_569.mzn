% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: rhs1 = 1000;
int: rhs2 = 600;
int: rhs3 = 500;

% Variables
var 0..rhs1: X1;
var 0..rhs1: X2;
var 0..rhs1: X3;

var 0..(c1*rhs1 + c2*rhs1 + c3*rhs1): total_cost;

% Constraints
constraint X1 + 2*X2 <= rhs1;
constraint X2 + 3*X3 >= rhs2;
constraint 2*X3 - X1 = rhs3;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;