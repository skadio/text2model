% Parameters
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: ub12 = 500;
int: ub34 = 600;

int: min13 = 300;
int: min24 = 400;

% Variables
var 0..ub12: x1;
var 0..ub12: x2;
var 0..ub34: x3;
var 0..ub34: x4;

var 0..(c1*ub12 + c2*ub12 + c3*ub34 + c4*ub34): total_cost;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 600;
constraint x1 + x3 >= 300;
constraint x2 + x4 >= 400;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;