% Parameters
int: c1 = 5000;
int: c2 = 4000;
int: c3 = 6000;
int: c4 = 7000;

int: ub1 = 30;
int: ub2 = 40;
int: ub3 = 50;
int: ub4 = 60;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 >= 10;
constraint x3 + x4 <= 20;
constraint 2*x2 - x1 - x3 >= 5;
constraint x4 - x1 - x2 >= 5;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;