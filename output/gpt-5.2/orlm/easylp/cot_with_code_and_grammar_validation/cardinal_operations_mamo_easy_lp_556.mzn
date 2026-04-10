% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;

int: ub_x1x2 = 10;
int: a21 = 4;
int: a23 = 5;
int: rhs2 = 20;

int: diff_max = 5;

% Variables
var 0..ub_x1x2: x1;
var 0..ub_x1x2: x2;
var 0..rhs2: x3;

var 0..(c1*ub_x1x2 + c2*ub_x1x2 + c3*rhs2): fatigue;

% Constraints
constraint x1 + x2 <= ub_x1x2;

constraint a21*x1 + a23*x3 >= rhs2;

constraint x3 - x2 <= diff_max;

constraint 2*x3 >= x1;

constraint fatigue = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize fatigue;