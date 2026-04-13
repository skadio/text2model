% Parameters
int: c1 = 20;
int: c2 = 30;
int: c3 = 10;
int: c4 = 15;

int: ub12 = 1000;
int: ub34 = 800;
int: lb123 = 500;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..800: x3;
var 0..800: x4;

var 0..(c1*1000 + c2*1000 + c3*800 + c4*800): total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2*x3 + x4 <= ub34;
constraint 3*x1 + 4*x2 - x3 >= lb123;
constraint x2 >= 2*x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;