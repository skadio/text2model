% Parameters
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: ub12 = 500;
int: ub34 = 700;
int: lb13 = 200;
int: lb24 = 300;

% Variables
var 0..ub12: x1;
var 0..ub12: x2;
var 0..ub34: x3;
var 0..ub34: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint x3 + x4 <= ub34;
constraint x1 + x3 >= lb13;
constraint x2 + x4 >= lb24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;