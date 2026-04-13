% Parameters
int: c1 = 200;
int: c2 = 300;
int: c3 = 500;
int: c4 = 1000;

int: total_cap = 100;

int: ub1 = 20;
int: ub2 = 30;
int: ub3 = 40;
int: ub4 = 50;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_cap;

constraint 10*x1 + 20*x2 >= 50;

constraint 3*x3 - 40*x4 <= 10;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2 to avoid fractions: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 140;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;