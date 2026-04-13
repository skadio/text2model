% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

int: ub1 = 100;
int: ub2 = 100;
int: ub3 = 100;
int: ub4 = 100;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;
constraint 2*x1 + 3*x2 - x3 <= 0;
constraint 4*x3 - 2*x2 = 5*x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;