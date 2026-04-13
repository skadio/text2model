% Parameters
int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

int: max1 = 600;
int: max2 = 400;
int: max3 = 500;
int: max4 = 300;

int: cap12 = 1000;
int: cap34 = 1200;
int: minTotal = 500;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

var 0..(c1*max1 + c2*max2 + c3*max3 + c4*max4): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint 2*x3 + 3*x4 <= cap34;
constraint x1 + x2 + x3 + x4 >= minTotal;
constraint 2*x1 > x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;