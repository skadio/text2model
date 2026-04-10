% Parameters (with values embedded)
int: MAX_X1_X2 = 1000;
int: MAX_X3_X4 = 1500;

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

% Variables
var 0..MAX_X1_X2: x1;
var 0..MAX_X1_X2: x2;
var 0..MAX_X3_X4: x3;
var 0..MAX_X3_X4: x4;

var 0..(c1*MAX_X1_X2 + c2*MAX_X1_X2 + c3*MAX_X3_X4 + c4*MAX_X3_X4): total_cost;

% Constraints
constraint x1 + x2 <= MAX_X1_X2;
constraint x3 + x4 <= MAX_X3_X4;

% "x1 must be at least twice that of half the number of x3" -> x1 >= 2*(x3/2) = x3
constraint x1 >= x3;

% "no more than half the number of x4 can be added ... without exceeding the count of x2 by 400"
% -> x2 + 400 >= x4/2  <=>  2*x2 + 800 >= x4
constraint 2*x2 + 800 >= x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;