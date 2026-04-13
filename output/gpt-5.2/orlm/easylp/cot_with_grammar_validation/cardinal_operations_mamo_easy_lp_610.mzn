% Parameters
int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 8;

int: max_x1 = 500;
int: max_x2 = 400;
int: max_x3 = 300;
int: max_x4 = 200;

int: lim1 = 1500;
int: thr2 = 1000;
int: lim3 = 600;
int: deficit = 200;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3 + c4*max_x4): total_cost;

% Constraints
constraint x1 + 2*x2 <= lim1;
constraint 3*x1 + x3 >= thr2;
constraint 4*x4 - x2 <= lim3;
constraint x2 + x3 + x4 - x1 = -deficit;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;