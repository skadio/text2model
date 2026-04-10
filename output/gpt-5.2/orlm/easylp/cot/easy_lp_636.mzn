% Parameters (with values embedded)
int: cost1 = 300;
int: cost2 = 200;
int: cost3 = 100;
int: cost4 = 50;

% Big-M style bounds to keep variables finite (no explicit upper bounds given)
int: UB = 10000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint x1 + x2 <= 500;

% 2*x1 + 3.5*x3 >= 700  -> multiply by 2 to keep integer coefficients:
% 4*x1 + 7*x3 >= 1400
constraint 4*x1 + 7*x3 >= 1400;

% x2 - 0.5*x3 - x1 <= 300  -> multiply by 2:
% 2*x2 - x3 - 2*x1 <= 600
constraint 2*x2 - x3 - 2*x1 <= 600;

% 0.5*x4 - x2 <= 400  -> multiply by 2:
% x4 - 2*x2 <= 800
constraint x4 - 2*x2 <= 800;

% x4 <= x1 - 150
constraint x4 <= x1 - 150;

% Objective
var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;
solve minimize total_cost;