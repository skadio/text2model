% Parameters
int: total12 = 400;
int: max1 = 300;
int: max2 = 200;

int: max34 = 1000;
int: max3 = 500;
int: max4 = 700;

int: c1 = 20;
int: c2 = 15;
int: c3 = 10;
int: c4 = 5;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

var 0..(c1*max1 + c2*max2 + c3*max3 + c4*max4): total_cost;

% Constraints
constraint x1 + x2 = total12;
constraint x3 + x4 <= max34;
constraint x3 + x4 >= x1 + x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;