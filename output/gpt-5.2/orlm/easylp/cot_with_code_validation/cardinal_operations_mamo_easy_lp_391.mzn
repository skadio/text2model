% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [10, 15, 25, 35];

int: min_x1x2 = 20;
int: max_x3x4 = 40;
int: min_x1_minus_2x3 = 5;
int: max_x4_minus_x2 = 10;

% Bounds (not specified in the description; use nonnegative integers)
array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [1000000, 1000000, 1000000, 1000000];

% Variables
array[P] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in P)(x[i] >= lb[i]);
constraint forall(i in P)(x[i] <= ub[i]);

constraint x[1] + x[2] >= min_x1x2;
constraint x[3] + x[4] <= max_x3x4;
constraint x[1] - 2 * x[3] >= min_x1_minus_2x3;
constraint x[4] - x[2] <= max_x4_minus_x2;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;