% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: ub1 = 1000;
int: ub2 = 1000;
int: ub3 = 1000;
int: ub4 = 1000;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 >= 500;

% 2*x1 should not fall short of (1/2)*x3 by more than 300:
% 2*x1 >= (1/2)*x3 - 300  <=>  4*x1 >= x3 - 600
constraint 4*x1 >= x3 - 600;

constraint (x1 + x2) - x4 <= 400;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;