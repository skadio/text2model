% Parameters
int: c1 = 5;
int: c2 = 4;
int: c3 = 6;

int: ub_x1 = 100;
int: ub_x2 = 100;
int: ub_x3 = 100;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;

var 0..(c1*ub_x1 + c2*ub_x2 + c3*ub_x3): total_cost;

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + 3*x3 >= 150;
constraint 4*x2 - x3 <= 200;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;