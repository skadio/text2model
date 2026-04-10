% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;
int: c4 = 7;

int: ub_x1x2 = 1000;
int: lb_x2x3 = 800;
int: diff_x3x4 = 200;
int: ub_halfx4_minus_x1 = 300;

% (No explicit variable bounds were provided beyond integrality in the description)
int: BIGM = 1000000;

% Variables
var 0..BIGM: x1;
var 0..BIGM: x2;
var 0..BIGM: x3;
var 0..BIGM: x4;

% Constraints
constraint x1 + x2 <= ub_x1x2;
constraint x2 + x3 >= lb_x2x3;
constraint x3 - x4 = diff_x3x4;
constraint x4 - 2*x1 <= 2*ub_halfx4_minus_x1;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;