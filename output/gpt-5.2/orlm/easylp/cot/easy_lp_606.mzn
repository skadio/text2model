% Parameters (with values embedded)
int: n = 4;
array[1..n] of int: cost = [2, 3, 4, 5];

int: max_x1 = 1000;
int: max_x2 = 1000;
int: max_x3 = 1000;
int: max_x4 = 1000;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 >= 500;

% 2*x1 should not fall short of 0.5*x3 by more than 300:
% 2*x1 >= 0.5*x3 - 300  <=>  4*x1 - x3 >= -600
constraint 4*x1 - x3 >= -600;

% (x1 + x2) - x4 should not exceed 400
constraint x1 + x2 - x4 <= 400;

% Objective
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;
solve minimize total_cost;