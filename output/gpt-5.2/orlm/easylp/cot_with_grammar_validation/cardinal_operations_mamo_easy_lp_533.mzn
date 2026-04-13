% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

int: rhs1 = 2000;
int: rhs2 = 1000;
int: rhs3 = 500;

% Variables
var 0..2000: x1;
var 0..1000: x2;
var 0..250: x3;

var 0..50000: total_cost;

% Constraints
constraint x1 + 2 * x2 <= rhs1;
constraint 3 * x1 + 4 * x3 >= rhs2;
constraint x2 - 5 * x3 <= rhs3;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_cost;