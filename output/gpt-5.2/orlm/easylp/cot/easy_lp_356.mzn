% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: cap12 = 100;     % x1 + x2 <= 100
int: rhs_23 = 50;     % 2*x1 + x3 >= 50
int: rhs_24 = 20;     % x2 - 3*x4 <= 20
int: rhs_41 = 10;     % x4 - 0.5*x1 >= 10  ==> 2*x4 - x1 >= 20

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Constraints
% Nonnegativity (resource allocations)
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% Problem constraints
constraint x1 + x2 <= cap12;
constraint 2*x1 + x3 >= rhs_23;
constraint x2 - 3*x4 <= rhs_24;
constraint 2*x4 - x1 >= 2*rhs_41;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;