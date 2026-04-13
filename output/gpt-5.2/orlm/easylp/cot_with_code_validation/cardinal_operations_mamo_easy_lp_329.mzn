% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: ub_x1x2 = 100;
int: rhs_2x1_plus_x3 = 150;
int: rhs_x2_minus_3x4 = 50;
int: rhs_x3_minus_x4 = 20;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Constraints
constraint x1 + x2 <= ub_x1x2;
constraint 2*x1 + x3 >= rhs_2x1_plus_x3;
constraint x2 - 3*x4 <= rhs_x2_minus_3x4;
constraint x3 - x4 >= rhs_x3_minus_x4;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;