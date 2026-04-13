% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1 = 1000;
int: max_x2 = 1000;
int: max_x3 = 1000;
int: max_x4 = 1000;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3 + c4*max_x4): total_cost;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 >= 500;

% 2*x1 should not fall short of (x3/2) by less than 300:
% 2*x1 >= x3/2 - 300  <=> 4*x1 >= x3 - 600
constraint 4*x1 - x3 >= -600;

constraint x1 + x2 - x4 <= 400;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;