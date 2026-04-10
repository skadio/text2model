% Parameters
int: CAP = 1000;

int: c1 = 5;
int: c2 = 8;
int: c3 = 6;

int: rhs1 = 200;  % 2*X1 - 3*X2 >= 200
int: rhs2 = 500;  % 4*X3 - X1 <= 500

% Variables
var 0..CAP: X1;
var 0..CAP: X2;
var 0..CAP: X3;

var 0..(CAP * max([c1, c2, c3])): TotalCost;

% Constraints
constraint X1 + X2 + X3 <= CAP;

constraint 2 * X1 - 3 * X2 >= rhs1;

constraint 4 * X3 - X1 <= rhs2;

constraint TotalCost = c1 * X1 + c2 * X2 + c3 * X3;

% Objective
solve minimize TotalCost;