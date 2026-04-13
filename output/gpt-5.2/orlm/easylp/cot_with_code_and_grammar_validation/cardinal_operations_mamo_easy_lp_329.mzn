% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: b12_max = 100;
int: b13_min = 150;
int: b24_max = 50;
int: b34_min = 20;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost;

% Constraints
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

constraint x1 + x2 <= b12_max;
constraint 2*x1 + x3 >= b13_min;
constraint x2 - 3*x4 <= b24_max;
constraint x3 - x4 >= b34_min;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;