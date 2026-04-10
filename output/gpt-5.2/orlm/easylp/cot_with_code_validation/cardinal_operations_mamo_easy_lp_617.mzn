% Parameters
int: c1 = 200;
int: c2 = 300;
int: c3 = 150;
int: c4 = 400;

int: max_x1 = 1000;
int: max_x2 = 1000;
int: max_x3 = 1200;
int: max_x4 = 1000;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x2 + x3 <= 1200;

% 3*x1 - 0.5*x3 >= 500  <=>  6*x1 - x3 >= 1000
constraint 6*x1 - x3 >= 1000;

constraint x4 >= x1;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;