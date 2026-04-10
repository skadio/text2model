% Parameters
int: c1 = 200;
int: c2 = 300;
int: c3 = 400;
int: c4 = 500;

int: cap12 = 1000;
int: cap34 = 1200;
int: minTotal = 500;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: totalCost;

% Constraints
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

constraint x1 + x2 <= cap12;
constraint 2 * x3 + x4 <= cap34;
constraint x1 + x2 + x3 + x4 >= minTotal;

constraint totalCost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize totalCost;