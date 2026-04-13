% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

int: ub12 = 50;
int: ub34 = 80;
int: lb13 = 30;
int: lb24 = 40;

% Variables
var 0..ub12: X1;
var 0..ub12: X2;
var 0..ub34: X3;
var 0..ub34: X4;

var 0..(c1*ub12 + c2*ub12 + c3*ub34 + c4*ub34): total_cost;

% Constraints
constraint X1 + X2 <= ub12;
constraint X3 + X4 <= ub34;

constraint X1 + X3 >= lb13;
constraint X2 + X4 >= lb24;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;