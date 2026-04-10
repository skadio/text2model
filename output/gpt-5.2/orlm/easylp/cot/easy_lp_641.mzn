% Parameters (with values embedded)
int: cost1 = 100;
int: cost2 = 150;
int: cost3 = 80;
int: cost4 = 50;

% To avoid fractional coefficients in constraint 4, scale by 2:
% 6*x2 + 7.5*x3 - 8.5*x4 - x1 <= 3000
% <=> 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Constraints
% (Bounds were referenced but not provided explicitly; assume non-negative allocations.)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

constraint 3*x1 + 2*x2 - x3 <= 5000;
constraint 4*x2 + x4 - x1 >= 2000;
constraint 5*x3 - x1 - x2 - x4 = 4000;
constraint 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000;

% Objective
solve minimize total_cost;