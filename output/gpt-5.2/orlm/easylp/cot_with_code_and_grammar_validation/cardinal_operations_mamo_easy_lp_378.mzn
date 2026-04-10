% Parameters
int: c1 = 50;
int: c2 = 80;
int: c3 = 30;
int: c4 = 70;

int: ub1 = 25;
int: ub2 = 25;
int: ub3 = 35;
int: ub4 = 35;

int: cap12 = 40;
int: cap34 = 60;

int: min13 = 20;
int: min24 = 30;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;