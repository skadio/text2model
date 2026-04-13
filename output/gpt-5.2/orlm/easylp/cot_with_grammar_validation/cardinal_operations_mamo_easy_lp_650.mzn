% Parameters
int: max_x1_x2 = 1000;
int: max_x3_x4 = 1500;

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

% Variables
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

var 0..(c1*max_x1_x2 + c2*max_x1_x2 + c3*max_x3_x4 + c4*max_x3_x4): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% x1 must be at least twice half of x3 => x1 >= x3
constraint x1 >= x3;

% "no more than half the number of x4 can be added ... without exceeding x2 by 400"
% Interpreted as: x2 <= x4 div 2 + 400  <=>  x4 <= 2*(x2 - 400) is not always feasible for small x2
% Use the direct inequality with integer division:
constraint x2 <= (x4 div 2) + 400;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;