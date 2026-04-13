% Parameters
int: c1 = 10;
int: c2 = 9;
int: c3 = 11;
int: c4 = 12;

int: ub12 = 500;   % x1 + x2 <= 500
int: ub34 = 400;   % x3 + x4 <= 400
int: lb13 = 300;   % x1 + x3 >= 300
int: lb24 = 600;   % x2 + x4 >= 600

% Variables
var 0..500: x1;
var 0..500: x2;
var 0..400: x3;
var 0..400: x4;

var 0..(c1*500 + c2*500 + c3*400 + c4*400): total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint x3 + x4 <= ub34;
constraint x1 + x3 >= lb13;
constraint x2 + x4 >= lb24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;