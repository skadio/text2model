% Parameters
int: c1 = 5;
int: c2 = 4;
int: c3 = 6;

int: max_x1x2 = 100;
int: min_2x1_3x3 = 150;
int: max_4x2_minus_x3 = 200;

% Bounds (not specified in the description; assume non-negative integer allocations)
int: LB = 0;
int: UB = 1000;

% Variables
var LB..UB: x1;
var LB..UB: x2;
var LB..UB: x3;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 2 * x1 + 3 * x3 >= min_2x1_3x3;
constraint 4 * x2 - x3 <= max_4x2_minus_x3;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_cost;