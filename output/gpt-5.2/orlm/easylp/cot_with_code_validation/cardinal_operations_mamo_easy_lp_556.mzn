% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;

int: max_x1_x2 = 10;
int: req_4x1_5x3 = 20;
int: max_diff_x3_x2 = 5;

% Variables
var 0..10: x1;
var 0..10: x2;
var 0..20: x3;

var 0..200: fatigue;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint 4*x1 + 5*x3 >= req_4x1_5x3;
constraint x3 - x2 <= max_diff_x3_x2;
constraint x2 - x3 <= max_diff_x3_x2;
constraint 2*x3 >= x1;

constraint fatigue = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize fatigue;