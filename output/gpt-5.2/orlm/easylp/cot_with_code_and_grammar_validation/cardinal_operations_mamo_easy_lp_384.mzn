% Parameters
int: c1 = 20;
int: c2 = 30;
int: c3 = 50;
int: c4 = 60;

int: lb1 = 0; int: ub1 = 15;
int: lb2 = 0; int: ub2 = 12;
int: lb3 = 0; int: ub3 = 10;
int: lb4 = 0; int: ub4 = 8;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 >= 5;
constraint abs(x3 - x4) <= 10;
constraint 2*x1 + 3*x2 - x4 >= 8;
constraint abs(x1 - x3) <= 6;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;