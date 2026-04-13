% Parameters
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: ub1 = 20;
int: ub2 = 15;
int: ub3 = 25;
int: ub4 = 30;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= 30;
constraint 2*x3 + x4 <= 40;
constraint x1 + x2 + x3 >= 20;
constraint 2*x3 - x4 <= 20;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;