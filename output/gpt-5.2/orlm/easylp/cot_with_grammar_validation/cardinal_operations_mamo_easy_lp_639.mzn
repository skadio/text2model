% Parameters
int: UB1 = 20;
int: UB2 = 30;
int: UB3 = 40;
int: UB4 = 50;

int: total_cap = 100;

int: c1 = 200;
int: c2 = 300;
int: c3 = 500;
int: c4 = 1000;

int: rhs_research = 50;
int: rhs_strategic = 10;
int: rhs_ops = 70;

% Variables
var 0..UB1: x1;
var 0..UB2: x2;
var 0..UB3: x3;
var 0..UB4: x4;

var 0..(c1*UB1 + c2*UB2 + c3*UB3 + c4*UB4): total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_cap;

constraint 10*x1 + 20*x2 >= rhs_research;

constraint 3*x3 - 40*x4 <= rhs_strategic;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2 to keep it integral: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 2*rhs_ops;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;