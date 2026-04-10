% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 12;
int: c4 = 20;

int: ub1 = 8;
int: ub2 = 8;
int: ub3 = 10;
int: ub4 = 10;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): fatigue;

% Constraints
constraint x1 + x2 <= 8;
constraint x3 + x4 <= 10;
constraint x1 + x3 >= 5;
constraint x2 + x4 >= 6;

constraint fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize fatigue;