% Parameters
int: c1 = 100;
int: c2 = 50;
int: c3 = 30;
int: c4 = 200;

int: lb1 = 0;
int: ub1 = 1000;
int: lb2 = 0;
int: ub2 = 1000;
int: lb3 = 0;
int: ub3 = 1000;
int: lb4 = 0;
int: ub4 = 1000;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 >= 10;
constraint x3 + x4 >= 20;
constraint 5*x1 - 2*x2 <= 0;
constraint 3*x3 - x4 >= 0;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;