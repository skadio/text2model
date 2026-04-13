% Parameters
int: c1 = 5;
int: c2 = 3;
int: c3 = 2;
int: c4 = 7;

int: rhs1 = 150;
int: rhs2 = 30;
int: rhs3 = 10;
int: rhs4 = 80;

% Variables
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

var 0..1000000: total_cost;

% Constraints
constraint 2*x1 + 3*x2 <= rhs1;
constraint x1 + x4 >= rhs2;
constraint x3 - x4 <= rhs3;
constraint x4 - x3 <= rhs3;
constraint 4*x1 + 5*x2 + x3 >= rhs4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;