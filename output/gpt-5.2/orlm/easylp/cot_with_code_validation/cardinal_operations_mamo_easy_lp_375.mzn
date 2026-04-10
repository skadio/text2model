% Parameters
int: c1 = 50;
int: c2 = 70;
int: c3 = 90;
int: c4 = 110;

int: ub1 = 20;
int: ub2 = 15;
int: ub3 = 10;
int: ub4 = 5;

int: b12 = 40;
int: b23 = 30;
int: b34 = 20;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= b12;
constraint x2 + x3 <= b23;
constraint x3 + x4 <= b34;

constraint x1 >= (x4 div 2) + 10;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;